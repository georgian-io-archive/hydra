resource "aws_lambda_function" "initialize_db" {
  filename      = var.lambda_function_file_path
  function_name = var.lambda_function_name
  role          = var.lambda_service_role_arn
  timeout       = var.lambda_function_timeout
  handler       = "batch_lambda.initialize_db"
  runtime       = "python3.8"

  vpc_config {
    security_group_ids  = var.lambda_security_group_ids
    subnet_ids          = var.lambda_subnets
  }
}

data "aws_lambda_invocation" "db_init" {
  function_name = aws_lambda_function.initialize_db.function_name

  input = <<JSON
  {
    "table_setup_script_bucket_name" : "${var.table_setup_script_bucket_name}",
    "table_setup_script_bucket_key" : "${var.table_setup_script_bucket_key}",
    "database_hostname" : "${var.database_hostname}",
    "database_username_secret" : "${var.database_username_secret}",
    "database_password_secret" : "${var.database_password_secret}",
    "database_default_name" : "${var.database_default_name}",
    "aws_region" : "${var.aws_region}"
  }
  JSON
}