variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "compute_environments" {
  type = list
}

variable "compute_environment_instance_role" {
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

variable "compute_environment_subnets" {
  type = list(string)
}

variable "compute_environment_resource_type" {
  type = string
}

variable "compute_environment_service_role" {
  type = string
}

variable "compute_environment_type" {
  type = string
}

variable "job_queues" {
}

variable "job_queue_priority" {
  type = number
}

variable "job_queue_state" {
  type = string
}