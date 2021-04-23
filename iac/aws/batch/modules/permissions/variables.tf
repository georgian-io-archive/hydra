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
