terraform {
  required_version = ">= 0.14"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.7"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "container_repository" {
  source                      = "./modules/container_repository"
  mlflow_container_repository = var.mlflow_container_repository
  scan_on_push                = var.scan_on_push
}

module "permissions" {
  source                  = "./modules/permissions"
  cidr_blocks             = var.sg_cidr_blocks
  ecs_task_iam_policy_arn = var.ecs_task_iam_policy_arn
  mlflow_ecs_tasks_role   = var.mlflow_ecs_tasks_role
  mlflow_sg               = var.mlflow_sg
  vpc_id                  = var.vpc_id
}

module "networking" {
  source                = "./modules/networking"
  rds_subnet_group_name = var.rds_subnet_group_name
  rds_subnets           = var.subnets
}

module "secrets" {
  source                    = "./modules/secrets"
  password_length           = var.password_length
  password_recovery_window  = var.password_recovery_window
  password_secret_name      = var.password_secret_name
  username_length           = var.username_length
  username_recovery_window  = var.username_recovery_window
  username_secret_name      = var.username_secret_name
}

module "load_balancing" {
  source              = "./modules/load_balancing"
  lb_name             = var.lb_name
  lb_security_groups  = [module.permissions.mlflow_sg_id]
  lb_subnets          = var.subnets
  lb_target_group     = var.lb_target_group
  vpc_id              = var.vpc_id
  lb_is_internal      = var.lb_is_internal
}

module "storage" {
  source                          = "./modules/storage"
  allocated_storage               = var.allocated_storage
  db_default_name                 = var.db_default_name
  db_engine_version               = var.db_engine_version
  db_instance_class               = var.db_instance_class
  db_password                     = module.secrets.password
  db_subnet_group_name            = module.networking.db_subnet_group
  db_username                     = module.secrets.username
  mlflow_artifact_store           = var.mlflow_artifact_store
  mlflow_backend_store_identifier = var.mlflow_backend_store_identifier
  skip_final_snapshot             = var.skip_final_snapshot
  storage_type                    = var.storage_type
  vpc_security_groups             = [module.permissions.mlflow_sg_id]
}

module "task_deployment" {
  source                      = "./modules/task_deployment"
  admin_password_arn          = module.secrets.password_arn
  admin_username_arn          = module.secrets.username_arn
  aws_lb_target_group_arn     = module.load_balancing.lb_target_group_arn
  aws_region                  = var.aws_region
  cloudwatch_log_group        = var.cloudwatch_log_group
  container_name              = var.container_name
  db_host                     = module.storage.db_host
  db_name                     = module.storage.db_name
  db_port                     = "3306"
  docker_image                = "${module.container_repository.container_repository_url}:latest"
  ecs_service_name            = var.ecs_service_name
  ecs_service_security_groups = [module.permissions.mlflow_sg_id]
  ecs_service_subnets         = var.subnets
  execution_role_arn          = module.permissions.mlflow_ecs_tasks_role_arn
  mlflow_ecs_task_family      = var.mlflow_ecs_task_family
  mlflow_server_cluster       = var.mlflow_server_cluster
  s3_bucket_folder            = var.artifact_store_folder
  s3_bucket_name              = module.storage.s3_bucket
  task_cpu                    = var.task_cpu
  task_memory                 = var.task_memory
  task_role_arn               = module.permissions.mlflow_ecs_tasks_role_arn
}

module "autoscaling" {
  source                          = "./modules/autoscaling"
  ecs_service_name                = module.task_deployment.ecs_service_name
  max_tasks                       = var.max_tasks
  min_tasks                       = var.min_tasks
  server_cluster_name             = module.task_deployment.ecs_cluster_name
  memory_autoscaling_policy_name  = var.memory_autoscaling_policy_name
  cpu_autoscaling_policy_name     = var.cpu_autoscaling_policy_name
  cpu_autoscale_in_cooldown       = var.cpu_autoscale_in_cooldown
  cpu_autoscale_out_cooldown      = var.cpu_autoscale_out_cooldown
  cpu_autoscale_target            = var.cpu_autoscale_target
  memory_autoscale_in_cooldown    = var.memory_autoscale_in_cooldown
  memory_autoscale_out_cooldown   = var.memory_autoscale_out_cooldown
  memory_autoscale_target         = var.memory_autoscale_target
}
