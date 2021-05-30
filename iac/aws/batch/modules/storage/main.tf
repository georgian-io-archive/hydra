resource "aws_s3_bucket_object" "db_schema_setup_script" {
  bucket                              = var.db_schema_setup_script_bucket_name
  key                                 = var.db_schema_setup_script_bucket_key
  source                              = var.db_schema_setup_script_local_path
}

resource "aws_db_instance" "batch_database" {
  identifier                          = var.db_batch_backend_store_identifier
  allocated_storage                   = var.db_allocated_storage
  storage_type                        = var.db_storage_type
  engine                              = "mysql"
  engine_version                      = var.db_engine_version
  instance_class                      = var.db_instance_class
  name                                = var.db_default_name
  username                            = var.db_username
  password                            = var.db_password
  db_subnet_group_name                = var.db_subnet_group_name
  vpc_security_group_ids              = var.db_security_groups
  skip_final_snapshot                 = var.db_skip_final_snapshot
  publicly_accessible                 = var.db_publicly_accessible
  iam_database_authentication_enabled = true
}
