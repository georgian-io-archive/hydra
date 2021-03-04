resource "aws_db_subnet_group" "db_subnet_group" {
  name        = var.rds_subnet_group_name
  subnet_ids  = var.rds_subnets
}
