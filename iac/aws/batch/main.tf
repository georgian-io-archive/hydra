terraform {
  required_version = ">= 0.14"

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

module "secrets" {
  source                    = "./modules/secrets"
  password_length           = var.password_random_length
  password_recovery_window  = var.password_recovery_window
  password_secret_name      = var.password_secret_name
  username_length           = var.username_random_length
  username_recovery_window  = var.username_recovery_window
  username_secret_name      = var.username_secret_name
}

module "storage" {
  source                          = "./modules/storage"
  allocated_storage               = var.allocated_storage
  batch_backend_store_identifier  = var.batch_backend_store_identifier
  db_default_name                 = var.db_default_name
  db_engine_version               = var.db_engine_version
  db_instance_class               = var.db_instance_class
  db_password                     = module.secrets.password
  db_subnet_group_name            = var.db_subnet_group_name
  db_username                     = module.secrets.username
  skip_final_snapshot             = var.skip_final_snapshot
  storage_type                    = var.storage_type
  vpc_security_groups             = var.vpc_security_groups
  publicly_accessible             = true
}

module "batch" {
  source                                  = "./modules/batch"
  aws_region                              = var.aws_region
  compute_environments                    = var.compute_environments
  compute_environment_instance_role       = var.compute_environment_instance_role
  compute_environment_resource_type       = var.compute_environment_resource_type
  compute_environment_instance_types      = var.compute_environment_instance_types
  compute_environment_max_vcpus           = var.compute_environment_max_vcpus
  compute_environment_min_vcpus           = var.compute_environment_min_vcpus
  compute_environment_security_group_ids  = var.compute_environment_security_group_ids
  compute_environment_service_role        = var.compute_environment_service_role
  compute_environment_subnets             = var.compute_environment_subnets
  compute_environment_type                = var.compute_environment_type
  job_queues                              = var.job_queues
  job_queue_priority                      = var.job_queue_priority
  job_queue_state                         = var.job_queue_state
}

resource "null_resource" "db_setup" {

  depends_on = [module.storage]

  provisioner "local-exec" {
    command = "mysqlsh --sql -u ${module.secrets.username} -p${module.secrets.password} -h ${module.storage.db_host} -P 3306 < ./table_setup.sql"
  }
}