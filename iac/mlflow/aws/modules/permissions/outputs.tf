output "mlflow_sg_id" {
  value       = aws_security_group.mlflow_sg.id
  description = "Security group ID"
}

output "mlflow_ecs_tasks_role_arn" {
  value       = aws_iam_role.mlflow_ecs_tasks_role.arn
  description = "ARN of ECS task executing IAM role"
}