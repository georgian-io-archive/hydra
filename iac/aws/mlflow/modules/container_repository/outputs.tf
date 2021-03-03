output "container_repository_url" {
  value       = aws_ecr_repository.mlflow_container_repository.repository_url
  description = "URL of docker container repository"
}