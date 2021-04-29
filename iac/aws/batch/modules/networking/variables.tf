variable "rds_subnet_group_name" {
  description = "RDS subnet group name"
  type        = string
}

variable "rds_subnets" {
  description = "Subnets attached to RDS"
  type        = list(string)
}