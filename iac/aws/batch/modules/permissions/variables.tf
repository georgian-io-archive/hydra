
variable "hydrabatch_sg" {
  description = "Security group name"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "cidr_blocks" {
  description = "List of CIDR blocks to allow ingress access"
  type        = list(string)
}
