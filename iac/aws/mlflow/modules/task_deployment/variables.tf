variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "mlflow_server_cluster" {
  description = "Name of MLFlow server cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of ECS Fargate service name"
  type        = string
}

variable "cloudwatch_log_group" {
  description = "Name of cloudwatch log group"
  type        = string
}

variable "mlflow_ecs_task_family" {
  description = "ECS task family name"
  type        = string
}

variable "container_name" {
  description = "Name of container"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of S3 bucket storing models"
  type        = string
}

variable "s3_bucket_folder" {
  description = "Name of folder within S3 bucket storing models"
  type        = string
}

variable "db_name" {
  description = "Name of database storing logs"
  type        = string
}

variable "db_host" {
  description = "Host of database storing logs"
  type        = string
}

variable "db_port" {
  description = "Port of database storing logs"
  type        = string
}

variable "docker_image" {
  description = "Path to docker image"
  type        = string
}

variable "task_memory" {
  description = "Memory set in deployment task in MiB"
  type        = number
}

variable "task_cpu" {
  description = "Number of CPU units in deployment task"
  type        = number
}

variable "admin_username_arn" {
  description = "ARN to RDS Admin Username secret"
  type        = string
}

variable "admin_password_arn" {
  description = "ARN to RDS Admin Password secret"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of task IAM role"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of execution IAM role"
  type        = string
}

variable "aws_lb_target_group_arn" {
  description = "ARN to load balancer target group"
  type        = string
}

variable "ecs_service_subnets" {
  description = "Subnets in network config of ECS Service"
  type        = list(string)
}

variable "ecs_service_security_groups" {
  description = "Attached security groups of ECS Service"
  type        = list(string)
}