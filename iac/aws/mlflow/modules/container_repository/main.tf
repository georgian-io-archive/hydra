resource "aws_ecr_repository" "mlflow_container_repository" {
  name = var.mlflow_container_repository

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}