output "ecs_service_name" {
  value       = aws_ecs_service.service.name
  description = "Name of ECS Service"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.mlflow_server_cluster.name
  description = "Name of ECS Cluster"
}