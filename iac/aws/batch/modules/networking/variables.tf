variable "db_subnet_group_name" {
  description = "RDS subnet group name"
  type        = string
}

variable "db_subnets" {
  description = "Subnets attached to RDS (recommended to match Hydra's subnets)"
  type        = list(string)
}
