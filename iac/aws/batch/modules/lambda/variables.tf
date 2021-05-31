variable "aws_region" {
  description = "AWS region"
  type = string
}

variable "lambda_service_role_arn" {
  description = "ARN of the IAM lambda function service role"
  type        = string
}

variable "lambda_function_file_path" {
  description = "File path of the lambda ZIP file that will be executed"
  type        = string
}

variable "lambda_function_timeout" {
  description = "Timeout of the executed lambda function"
  type        = number
}

variable "lambda_function_name" {
  description = "Name of the lambda function that will be created"
  type        = string
}

variable "lambda_security_group_ids" {
  description = "List of security groups to attach lambda function to"
  type        = list(string)
}

variable "lambda_subnets" {
  description = "List of subnets to attach lambda function to"
  type        = list(string)
}

variable "database_hostname" {
  description = "Hostname of the Batch RDS instance"
  type        = string
}

variable "database_username_secret" {
  description = "Secret name of the Batch RDS Username"
  type        = string
}

variable "database_password_secret" {
  description = "Secret name of the Batch RDS Password"
  type        = string
}

variable "database_default_name" {
  description = "Default database name created in RDS instance"
  type        = string
}

variable "db_schema_setup_script_bucket_name" {
  description = "The name of the S3 bucket that will store the table setup script"
  type        = string
}

variable "db_schema_setup_script_bucket_key" {
  description = "The key of the S3 bucket that will store the table setup script"
  type        = string
}
