variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "mlflow_artifact_store" {
  description = "Bucket name"
  type        = string
  default     = "hydra-mlflow-artifact-store"
}

variable "mlflow_server_cluster" {
  description = "Cluster name"
  type        = string
  default     = "mlflow-server-cluster"
}

variable "mlflow_ecs_tasks_role" {
  description = "IAM Role name"
  type        = string
  default     = "hydra_mlflow_ecs_tasks"
}

variable "mlflow_sg" {
  description = "Security group name"
  type        = string
  default     = "mlflow-sg"
}

variable "mlflow_container_repository" {
  description = "Container repository name"
  type        = string
  default     = "mlflow-container-repository"
}

variable "mlflow_ecs_task_family" {
  description = "ECS task family name"
  type        = string
  default     = "mlflow-deployment-task"
}

variable "ecs_task_iam_policy_arn" {
  description = "IAM policies attached to ECS task role"
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = "vpc-dc395aa7"
}

variable "rds_subnet_group_name" {
  description = "RDB subnet group name"
  type        = string
  default     = "hydra-mlflow-db-subnet"
}

variable "cloudwatch_log_group" {
  description = "Name of cloudwatch log group"
  type        = string
  default     = "/ecs/mlflow-deployment-task"
}

variable "ecs_service_name" {
  description = "Name of ECS Fargate service name"
  type        = string
  default     = "mlflow-deployment-service"
}

variable "alb_name" {
  description = "Name of ALB"
  type        = string
  default     = "hydra-mlflow-lb"
}

variable "container_name" {
  description = "Name of container"
  type        = string
  default     = "task"
}

variable "public_subnet_a" {
  description = "ID of public subnet a"
  type        = string
  default     = "subnet-9d2ccbfa"
}

variable "public_subnet_b" {
  description = "ID of public subnet b"
  type        = string
  default     = "subnet-6139fa4f"
}

variable "private_subnet_b" {
  description = "ID of private subnet b"
  type        = string
  default     = "subnet-6510d04b"
}
