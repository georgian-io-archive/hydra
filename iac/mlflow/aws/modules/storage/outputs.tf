output "db_host" {
  value       = aws_db_instance.mlflow_database.address
  description = "Hostname of RDS database instance"
}

output "db_name" {
  value       = aws_db_instance.mlflow_database.name
  description = "Name of used RDS database"
}

output "s3_bucket" {
  value       = aws_s3_bucket.mlflow_artifact_store.bucket
  description = "Name of the S3 bucket"
}