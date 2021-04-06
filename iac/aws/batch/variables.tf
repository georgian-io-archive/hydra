variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "password_random_length" {
  description = "Number of randomly generated characters in password"
  type = number
}

variable "password_recovery_window" {
  description = "Recovery window of password secret"
  type = number
}

variable "password_secret_name" {
  description = "Secret name containining Batch database password"
  type = string
}

variable "username_random_length" {
  description = "Number of randomly generated characters in username"
  type = number
}

variable "username_recovery_window" {
  description = "Recovery window of username secret"
  type = number
}

variable "username_secret_name" {
  description = "Secret name containining Batch database username"
  type = string
}

variable "batch_backend_store_identifier" {
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

variable "db_subnet_group_name" {
  description = "Database subnet group name"
  type        = string
}

variable "vpc_security_groups" {
  description = "VPC security groups associated with database"
  type        = list(string)
}

variable "compute_environments" {
  description = "List of maps of compute environments to be created; map key name is 'name', map value name is 'instance_type'"
  type        = list
}

variable "compute_environment_instance_role" {
  description = "Instance role to be used in compute environment"
  type        = string
}

variable "compute_environment_resource_type" {
  description = "Resource type to be used in compute environment: Valid options are 'EC2' or 'SPOT'"
  type        = string
}

variable "compute_environment_max_vcpus" {
  description = "Maximum vCPUs that the compute environment should maintain"
  type        = number
}

variable "compute_environment_min_vcpus" {
  description = "Minumum vCPUs that the compute environment should maintain"
  type        = number
}

variable "compute_environment_security_group_ids" {
  description = "EC2 security groups associated with instances within compute envrionment"
  type        = list(string)
}

variable "compute_environment_service_role" {
  description = "ARN of the IAM role allowing Batch to call other services"
  type        = string
}

variable "compute_environment_subnets" {
  description = "Subnets that compute resources are launched in"
  type        = list(string)
}

variable "compute_environment_type" {
  description = "The type of the compute environment: Valid options are 'MANAGED' or 'UNMANAGED'"
  type        = string
}

variable "job_queues"  {
  description = "List of maps of compute environments to be created; map key name is 'name', map value name is 'compute_environment'"
  type        = list
}

variable "job_queue_priority" {
  description = "Priority of the job queue"
  type        = number
}

variable "job_queue_state" {
  description = "The state of the job queue: Valid options are 'ENABLED' or 'DISABLED'"
  type        = string
}