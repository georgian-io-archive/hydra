output "db_subnet_group" {
  value       = aws_db_subnet_group.db_subnet_group.name
  description = "Subnet group associated with RDS rb"
}