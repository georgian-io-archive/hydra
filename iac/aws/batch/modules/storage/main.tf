resource "aws_s3_bucket_object" "table_setup_script" {
  bucket                              = var.table_setup_script_bucket_name
  key                                 = var.table_setup_script_bucket_key
  source                              = var.table_setup_script_local_path
}

resource "aws_db_instance" "batch_database" {
  identifier                          = var.batch_backend_store_identifier
  allocated_storage                   = var.allocated_storage
  storage_type                        = var.storage_type
  engine                              = "mysql"
  engine_version                      = var.db_engine_version
  instance_class                      = var.db_instance_class
  name                                = var.db_default_name
  username                            = var.db_username
  password                            = var.db_password
  db_subnet_group_name                = var.db_subnet_group_name
  vpc_security_group_ids              = var.vpc_security_groups
  skip_final_snapshot                 = var.skip_final_snapshot
  publicly_accessible                 = var.publicly_accessible
  iam_database_authentication_enabled = true
}