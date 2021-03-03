variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = "vpc-dc395aa7"
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

# container_repository
variable "mlflow_container_repository" {
  description = "Container repository name"
  type        = string
  default     = "mlflow-container-repository"
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
  default     = "mlflow_ecs_tasks_role"
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
  default     = "mlflow_sg"
}

variable "sg_cidr_blocks" {
  description = "CIDR Blocks to allow ingress access to required ports of security group"
  type        = list(string)
  default     = ["184.146.184.126/32"]
}

# networking
variable "rds_subnet_group_name" {
  description = "RDB subnet group name"
  type        = string
  default     = "mlflow-db-subnet"
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
  default     = "mlflow/admin_username"
}

variable "password_secret_name" {
  description = "Name of password storing secret"
  type        = string
  default     = "mlflow/admin_password"
}

# load_balancing
variable "lb_name" {
  description = "Name of LB"
  type        = string
  default     = "mlflow-lb"
}

variable "lb_target_group" {
  description = "Name of LB target group"
  type        = string
  default     = "ecs-mlflow-lb-tg"
}

# storage
variable "mlflow_artifact_store" {
  description = "Bucket name"
  type        = string
  default     = "hydra-mlflow-artifact-store"
}

variable "mlflow_backend_store_identifier" {
  description = "RDS Database identifier of MLflow backend store"
  type        = string
  default     = "mlflowdb"
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
  default     = "mlflowdb"
}

variable "skip_final_snapshot" {
  description = "Whether a final snapshot is created before database deletion"
  type        = bool
  default     = true
}

variable "ecs_service_name" {
  description = "Name of ECS Fargate service name"
  type        = string
  default     = "mlflow-deployment-service"
}

# task_deployment
variable "mlflow_ecs_task_family" {
  description = "ECS task family name"
  type        = string
  default     = "mlflow-deployment-task"
}


variable "mlflow_server_cluster" {
  description = "Cluster name"
  type        = string
  default     = "mlflow-server-cluster"
}

variable "cloudwatch_log_group" {
  description = "Name of cloudwatch log group"
  type        = string
  default     = "/ecs/mlflow-deployment-task"
}

variable "container_name" {
  description = "Name of container"
  type        = string
  default     = "task"
}

variable "artifact_store_folder" {
  description = "The folder name of the location artifacts are stored in S3"
  type        = string
  default     = "logging"
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
  default     = 8
}

variable "memory_autoscaling_policy_name" {
  description = "Name of memory autoscaling policy"
  type        = string
  default     = "memory-autoscale-mlflow"
}

variable "cpu_autoscaling_policy_name" {
  description = "Name of CPU autoscaling policy"
  type        = string
  default     = "cpu-autoscale-mlflow"
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

# subnet
variable "sns_subscription_protocol" {
  description = "SNS subscription protocol"
  type        = string
  default     = "email"
}

variable "sns_subscription_email_address_list" {
  description = "SNS subscription protocol"
  type        = list(string)
  default     = [
    "sayon.sivakumaran@georgian.io"
  ]
}