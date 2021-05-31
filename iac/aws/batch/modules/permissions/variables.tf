variable "compute_environment_service_role_name" {
  description = "IAM name of the compute environment service role"
  type        = string
}

variable "compute_environment_service_iam_policy_arn" {
  description = "IAM policies attached to compute environment serivce role"
  type        = list(string)
}

variable "compute_environment_instance_role_name" {
  description = "IAM name of the compute environment instance role"
  type        = string
}

variable "compute_environment_instance_iam_policy_arn" {
  description = "IAM policies attached to compute environment instance role"
  type        = list(string)
}

variable "lambda_service_role_name" {
  description = "IAM name of the lambda function service role"
  type        = string
}

variable "lambda_service_iam_policy_arn" {
  description = "IAM policies attached to the lambda function service role"
  type        = list(string)
}

variable "db_schema_setup_script_bucket_name" {
  description = "The name of the S3 bucket that will store the table setup script"
  type        = string
}

variable "db_schema_setup_script_bucket_key" {
  description = "The key of the S3 bucket that will store the table setup script"
  type        = string
}
