# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

provider "aws" {
  region = var.aws_region
}

module "autoscaling" {
  source                        = "./modules/autoscaling"
  ecs_service_name              = aws_ecs_service.service.name
  max_tasks                     = 8
  min_tasks                     = 2
  server_cluster_name           = aws_ecs_cluster.mlflow_server_cluster.name
  cpu_autoscale_in_cooldown     = 0
  cpu_autoscale_out_cooldown    = 0
  cpu_autoscale_target          = 80
  memory_autoscale_in_cooldown  = 0
  memory_autoscale_out_cooldown = 0
  memory_autoscale_target       = 80
}