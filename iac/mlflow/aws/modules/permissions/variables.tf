variable "mlflow_ecs_tasks_role" {
  description = "IAM Role name"
  type        = string
}

variable "ecs_task_iam_policy_arn" {
  description = "IAM policies attached to ECS task role"
  type        = list(string)
}

variable "mlflow_sg" {
  description = "Security group name"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "cidr_blocks" {
  description = "List of CIDR blocks to allow ingress access"
  type        = list(string)
}