variable "min_tasks" {
  description = "Minimum number of running tasks in ECS service"
  type        = number
}

variable "max_tasks" {
  description = "Maximum number of running tasks in ECS service"
  type        = number
}

variable "server_cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of MLFlow deployment service"
  type        = string
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
}

variable "cpu_autoscale_out_cooldown" {
  description = "Cooldown time for scale out of CPU metric"
  type        = number
}

variable "cpu_autoscale_target" {
  description = "Target value for CPU metric"
  type        = number
}

variable "memory_autoscale_in_cooldown" {
  description = "Cooldown time for scale in of memory metric"
  type        = number
}

variable "memory_autoscale_out_cooldown" {
  description = "Cooldown time for scale out of memory metric"
  type        = number
}

variable "memory_autoscale_target" {
  description = "Target value for memory metric"
  type        = number
}