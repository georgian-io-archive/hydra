resource "aws_iam_role" "lambda_service_role" {
  name                = var.lambda_service_role_name
  assume_role_policy  = data.aws_iam_policy_document.lambda_service_role_policy.json
}

data "aws_iam_policy_document" "lambda_service_role_policy" {
  version   = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_service_role_policy_attachment" {
  role        = aws_iam_role.lambda_service_role.name
  count       = length(var.lambda_service_iam_policy_arn)
  policy_arn  = var.lambda_service_iam_policy_arn[count.index]
}

resource "aws_lambda_function" "initialize_db" {
  filename      = var.lambda_function_file_path
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_service_role.arn
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