# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

provider "aws" {
  region = var.aws_region
}

module "container_repository" {
  source                      = "./modules/container_repository"
  mlflow_container_repository = var.mlflow_container_repository
  scan_on_push                = true
}

module "load_balancing" {
  source              = "./modules/load_balancing"
  lb_name             = var.alb_name
  lb_security_groups  = [aws_security_group.mlflow_sg.id]
  lb_subnets          = [var.public_subnet_a, var.public_subnet_b]
  lb_target_group     = var.alb_target_group
  vpc_id              = var.vpc_id
}

module "task_deployment" {
  source                      = "./modules/task_deployment"
  admin_password_arn          = aws_secretsmanager_secret.admin_password.arn
  admin_username_arn          = aws_secretsmanager_secret.admin_username.arn
  aws_lb_target_group_arn     = module.load_balancing.lb_target_group_arn
  aws_region                  = var.aws_region
  cloudwatch_log_group        = var.cloudwatch_log_group
  container_name              = var.container_name
  db_host                     = aws_db_instance.mlflowdb_tf_test.address
  db_name                     = aws_db_instance.mlflowdb_tf_test.name
  db_port                     = "3306"
  docker_image                = "${module.container_repository.container_repository_url}:latest"
  ecs_service_name            = var.ecs_service_name
  ecs_service_security_groups = [aws_security_group.mlflow_sg.id]
  ecs_service_subnets         = [var.public_subnet_a]
  execution_role_arn          = aws_iam_role.hydra_mlflow_ecs_tasks.arn
  mlflow_ecs_task_family      = var.mlflow_ecs_task_family
  mlflow_server_cluster       = var.mlflow_server_cluster
  s3_bucket_folder            = var.mlflow_artifact_store
  s3_bucket_name              = "logging"
  task_cpu                    = 512
  task_memory                 = 1024
  task_role_arn               = aws_iam_role.hydra_mlflow_ecs_tasks.arn
}

module "autoscaling" {
  source                        = "./modules/autoscaling"
  ecs_service_name              = module.task_deployment.ecs_service_name
  max_tasks                     = 8
  min_tasks                     = 2
  server_cluster_name           = module.task_deployment.ecs_cluster_name
  cpu_autoscale_in_cooldown     = 0
  cpu_autoscale_out_cooldown    = 0
  cpu_autoscale_target          = 80
  memory_autoscale_in_cooldown  = 0
  memory_autoscale_out_cooldown = 0
  memory_autoscale_target       = 80
}