output "db_host" {
  value       = aws_db_instance.batch_database.address
  description = "Hostname of RDS database instance"
}