output "db_host" {
  value       = aws_db_instance.mlflowdb.address
  description = "Hostname of RDS database instance"
}

output "db_name" {
  value       = aws_db_instance.mlflowdb.name
  description = "Name of used RDS database"
}