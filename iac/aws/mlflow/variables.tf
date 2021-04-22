variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs that will be used in build"
  type        = list(string)
}

# container_repository
variable "mlflow_container_repository" {
  description = "Container repository name"
  type        = string
}

variable "scan_on_push" {
  description = "Scan docker image in repo on push"
  type        = bool
  default     = false
}

# permissions
variable "mlflow_ecs_tasks_role" {
  description = "IAM Role name"
  type        = string
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

variable "mlflow_sg" {
  description = "Security group name"
  type        = string
}

variable "sg_cidr_blocks" {
  description = "CIDR Blocks to allow ingress access to required ports of security group"
  type        = list(string)
}

# networking
variable "rds_subnet_group_name" {
  description = "RDB subnet group name"
  type        = string
}

# secrets
variable "username_length" {
  description = "Number of characters in username"
  type        = number
  default     = 20
}

variable "password_length" {
  description = "Number of characters in username"
  type        = number
  default     = 20
}

variable "username_recovery_window" {
  description = "Number of days before Secret can be deleted"
  type        = number
  default     = 0
}

variable "password_recovery_window" {
  description = "Number of days before Secret can be deleted"
  type        = number
  default     = 0
}

variable "username_secret_name" {
  description = "Name of username storing secret"
  type        = string
}

variable "password_secret_name" {
  description = "Name of password storing secret"
  type        = string
}

# load_balancing
variable "lb_name" {
  description = "Name of LB"
  type        = string
}

variable "lb_target_group" {
  description = "Name of LB target group"
  type        = string
}

# storage
variable "mlflow_artifact_store" {
  description = "Bucket name"
  type        = string
}

variable "mlflow_backend_store_identifier" {
  description = "RDS Database identifier of MLflow backend store"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage of RDS instance"
  type        = string
  default     = 20
}

variable "storage_type" {
  description = "RDS Storage type"
  type        = string
  default     = "standard"
}

variable "db_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "5.7"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "db_default_name" {
  description = "Name of default created database in instance"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Whether a final snapshot is created before database deletion"
  type        = bool
  default     = true
}

# task_deployment
variable "ecs_service_name" {
  description = "Name of ECS Fargate service name"
  type        = string
}

variable "mlflow_ecs_task_family" {
  description = "ECS task family name"
  type        = string
}


variable "mlflow_server_cluster" {
  description = "Cluster name"
  type        = string
}

variable "cloudwatch_log_group" {
  description = "Name of cloudwatch log group"
  type        = string
}

variable "container_name" {
  description = "Name of container"
  type        = string
}

variable "artifact_store_folder" {
  description = "The folder name of the location artifacts are stored in S3"
  type        = string
}

variable "task_memory" {
  description = "Memory set in deployment task in MiB"
  type        = number
  default     = 1024
}

variable "task_cpu" {
  description = "Number of CPU units in deployment task"
  type        = number
  default     = 512
}

# autoscaling
variable "min_tasks" {
  description = "Minimum number of running tasks in ECS service"
  type        = number
  default     = 2
}

variable "max_tasks" {
  description = "Maximum number of running tasks in ECS service"
  type        = number
  default     = 16
}

variable "memory_autoscaling_policy_name" {
  description = "Name of memory autoscaling policy"
  type        = string
}

variable "cpu_autoscaling_policy_name" {
  description = "Name of CPU autoscaling policy"
  type        = string
}

variable "cpu_autoscale_in_cooldown" {
  description = "Cooldown time for scale in of CPU metric"
  type        = number
  default     = 0
}

variable "cpu_autoscale_out_cooldown" {
  description = "Cooldown time for scale out of CPU metric"
  type        = number
  default     = 0
}

variable "cpu_autoscale_target" {
  description = "Target value for CPU metric"
  type        = number
  default     = 80
}

variable "memory_autoscale_in_cooldown" {
  description = "Cooldown time for scale in of memory metric"
  type        = number
  default     = 0
}

variable "memory_autoscale_out_cooldown" {
  description = "Cooldown time for scale out of memory metric"
  type        = number
  default     = 0
}

variable "memory_autoscale_target" {
  description = "Target value for memory metric"
  type        = number
  default     = 80
}