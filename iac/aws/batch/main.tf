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

module "permissions" {
  source                                      = "./modules/permissions"
  compute_environment_service_role_name       = var.compute_environment_service_role_name
  compute_environment_service_iam_policy_arn  = var.compute_environment_service_iam_policy_arn
  compute_environment_instance_role_name      = var.compute_environment_instance_role_name
  compute_environment_instance_iam_policy_arn = var.compute_environment_instance_iam_policy_arn
  lambda_service_role_name                    = var.lambda_service_role_name
  lambda_service_iam_policy_arn               = var.lambda_service_iam_policy_arn
  db_schema_setup_script_bucket_name  = module.storage.db_schema_setup_script_bucket_name
  db_schema_setup_script_bucket_key   = module.storage.db_schema_setup_script_bucket_key
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

module "networking" {
  source                = "./modules/networking"
  db_subnet_group_name  = var.db_subnet_group_name
  db_subnets            = var.db_subnets
}

module "storage" {
  source                              = "./modules/storage"
  db_schema_setup_script_bucket_name  = var.db_schema_setup_script_bucket_name
  db_schema_setup_script_bucket_key   = var.db_schema_setup_script_bucket_key
  db_schema_setup_script_local_path   = "./modules/storage/scripts/schema_setup_v_0_0_1.sql"
  db_allocated_storage                = var.db_allocated_storage
  db_batch_backend_store_identifier   = var.db_batch_backend_store_identifier
  db_default_name                     = var.db_default_name
  db_engine_version                   = var.db_engine_version
  db_instance_class                   = var.db_instance_class
  db_username                         = module.secrets.username
  db_password                         = module.secrets.password
  db_subnets                          = var.db_subnets
  db_subnet_group_name                = module.networking.db_subnet_group
  db_skip_final_snapshot              = var.db_skip_final_snapshot
  db_storage_type                     = var.db_storage_type
  db_security_groups                  = var.security_groups
  db_publicly_accessible              = var.db_publicly_accessible
}

module "batch" {
  source                                    = "./modules/batch"
  aws_region                                = var.aws_region
  compute_environments                      = var.compute_environments
  compute_environment_instance_profile_arn  = module.permissions.compute_environment_instance_profile_arn
  compute_environment_resource_type         = var.compute_environment_resource_type
  compute_environment_max_vcpus             = var.compute_environment_max_vcpus
  compute_environment_min_vcpus             = var.compute_environment_min_vcpus
  compute_environment_security_group_ids    = var.security_groups
  compute_environment_service_role_arn      = module.permissions.compute_environment_service_role_arn
  compute_environment_subnets               = var.subnets
  compute_environment_type                  = var.compute_environment_type
  job_queues                                = var.job_queues
  job_queue_priority                        = var.job_queue_priority
  job_queue_state                           = var.job_queue_state
}

module "lambda" {
  source                          = "./modules/lambda"
  lambda_service_role_arn         = module.permissions.lambda_service_role_arn
  lambda_function_file_path       = "./modules/lambda/function/batch_lambda.zip"
  lambda_function_name            = var.lambda_function_name
  lambda_function_timeout         = var.lambda_function_timeout
  lambda_security_group_ids       = var.security_groups
  lambda_subnets                  = var.subnets
  database_hostname               = module.storage.db_host
  database_username_secret        = module.secrets.username_secret
  database_password_secret        = module.secrets.password_secret
  database_default_name           = var.db_default_name
  db_schema_setup_script_bucket_name  = module.storage.db_schema_setup_script_bucket_name
  db_schema_setup_script_bucket_key   = module.storage.db_schema_setup_script_bucket_key
  aws_region                      = var.aws_region
}
