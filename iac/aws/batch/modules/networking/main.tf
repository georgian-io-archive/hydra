resource "aws_db_subnet_group" "hydradb_sg" {
  name        = var.rds_subnet_group_name
  subnet_ids  = var.rds_subnets
}
