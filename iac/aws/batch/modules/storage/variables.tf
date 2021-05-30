variable "db_schema_setup_script_bucket_name" {
  description = "The name of the S3 bucket that will store the table setup script"
  type        = string
}

variable "db_schema_setup_script_bucket_key" {
  description = "The key in the S3 bucket that will store the table setup script"
  type        = string
}

variable "db_schema_setup_script_local_path" {
  description = "The local path of the SQL script to be executed in RDS"
  type        = string
}

variable "db_batch_backend_store_identifier" {
  description = "RDS Database identifier of Batch backend store"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage of RDS instance"
  type        = string
}

variable "db_storage_type" {
  description = "RDS Storage type"
  type        = string
}

variable "db_engine_version" {
  description = "RDS engine version"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_default_name" {
  description = "Name of default created database in instance"
  type        = string
}

variable "db_username" {
  description = "RDS admin username"
  type        = string
}

variable "db_password" {
  description = "RDS admin password"
  type        = string
}

variable "db_subnets" {
  description = "Subnets attached to RDS"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group"
  type        = string
}

variable "db_security_groups" {
  description = "Security groups associated with RDS instance"
  type        = list(string)
}

variable "db_skip_final_snapshot" {
  description = "Whether a final snapshot is created before database deletion"
  type        = bool
}

variable "db_publicly_accessible" {
  description = "Whether the RDS instance is made publicly accesible"
  type        = bool
}
