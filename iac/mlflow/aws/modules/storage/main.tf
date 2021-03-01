resource "aws_s3_bucket" "mlflow_artifact_store" {
  bucket  = var.mlflow_artifact_store
  acl     = "private"
}

resource "aws_db_instance" "mlflowdb" {
  identifier              = var.mlflow_backend_store_identifier
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = "mysql"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  name                    = var.db_default_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = var.vpc_security_groups
  skip_final_snapshot     = var.skip_final_snapshot
}