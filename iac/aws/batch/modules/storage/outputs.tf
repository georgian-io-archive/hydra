output "db_host" {
  value       = aws_db_instance.batch_database.address
  description = "Hostname of RDS database instance"
}

output "table_setup_script_bucket_name" {
  value       = aws_s3_bucket_object.table_setup_script.bucket
  description = "S3 Bucket that stores the table setup SQL script"
}

output "table_setup_script_bucket_key" {
  value       = aws_s3_bucket_object.table_setup_script.key
  description = "S3 Key of bucket that stores the table setup SQL script"
}