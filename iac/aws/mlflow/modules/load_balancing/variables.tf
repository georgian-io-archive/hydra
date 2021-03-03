variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "lb_name" {
  description = "Name of ALB"
  type        = string
}

variable "lb_security_groups" {
  description = "List of security groups attached to Load Balancer"
  type        = list(string)
}

variable "lb_subnets" {
  description = "List of subnets attached to Load Balancer"
  type        = list(string)
}

variable "lb_target_group" {
  description = "Name of Load Balancer target group"
  type        = string
}