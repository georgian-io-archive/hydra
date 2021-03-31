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
  password_length           = 15
  password_recovery_window  = 0
  password_secret_name      = "batch/test/admin_password"
  username_length           = 15
  username_recovery_window  = 0
  username_secret_name      = "batch/test/admin_username"
}

module "storage" {
  source                          = "./modules/storage"
  allocated_storage               = 20
  batch_backend_store_identifier  = "batchdbtesttf"
  db_default_name                 = "batchdbtesttf"
  db_engine_version               = "5.7"
  db_instance_class               = "db.t2.micro"
  db_password                     = module.secrets.password
  db_subnet_group_name            = "mlflow-db-subnet"
  db_username                     = module.secrets.username
  skip_final_snapshot             = true
  storage_type                    = "standard"
  vpc_security_groups             = ["sg-0e1b104f9abab503f"]
  publicly_accessible             = true
}

resource "null_resource" "db_setup" {

  depends_on = [module.storage]

  provisioner "local-exec" {
    command = "mysqlsh --sql -u ${module.secrets.username} -p${module.secrets.password} -h ${module.storage.db_host} -P 3306 < ./table_setup.sql"
  }
}