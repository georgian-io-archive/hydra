variable "aws_region" {
  description = "AWS region"
  type        = string
}

# secrets
variable "password_random_length" {
  type = number
}

variable "password_recovery_window" {
  type = number
}

variable "password_secret_name" {
  type = string
}

variable "username_random_length" {
  type = number
}

variable "username_recovery_window" {
  type = number
}

variable "username_secret_name" {
  type = string
}

# storage
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

# TODO: migrate the last module to main
variable "compute_environments" {
  type = list
}

variable "compute_environment_instance_role" {
  type = string
}

variable "compute_environment_resource_type" {
  type = string
}

variable "compute_environment_instance_types" {
  type = list(string)
}

variable "compute_environment_max_vcpus" {
  type = number
}

variable "compute_environment_min_vcpus" {
  type = number
}

variable "compute_environment_security_group_ids" {
  type = list(string)
}

variable "compute_environment_service_role" {
  type = string
}

variable "compute_environment_subnets" {
  type = list(string)
}

variable "compute_environment_type" {
  type = string
}

variable "job_queues"  {
  type = list
}

variable "job_queue_priority" {
  type = number
}

variable "job_queue_state" {
  type = string
}