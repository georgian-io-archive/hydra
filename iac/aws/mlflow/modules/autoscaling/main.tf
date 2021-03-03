resource "aws_appautoscaling_target" "ecs_autoscaling_target" {
  max_capacity        = var.max_tasks
  min_capacity        = var.min_tasks
  resource_id         = "service/${var.server_cluster_name}/${var.ecs_service_name}"
  scalable_dimension  = "ecs:service:DesiredCount"
  service_namespace   = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_memory_autoscaling_policy" {
  name                = var.memory_autoscaling_policy_name
  policy_type         = "TargetTrackingScaling"
  resource_id         = aws_appautoscaling_target.ecs_autoscaling_target.resource_id
  scalable_dimension  = aws_appautoscaling_target.ecs_autoscaling_target.scalable_dimension
  service_namespace   = aws_appautoscaling_target.ecs_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value        = var.memory_autoscale_target
    scale_in_cooldown   = var.memory_autoscale_in_cooldown
    scale_out_cooldown  = var.memory_autoscale_out_cooldown
  }
}

resource "aws_appautoscaling_policy" "ecs_cpu_autoscaling_policy" {
  name                = var.cpu_autoscaling_policy_name
  policy_type         = "TargetTrackingScaling"
  resource_id         = aws_appautoscaling_target.ecs_autoscaling_target.resource_id
  scalable_dimension  = aws_appautoscaling_target.ecs_autoscaling_target.scalable_dimension
  service_namespace   = aws_appautoscaling_target.ecs_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value        = var.cpu_autoscale_target
    scale_in_cooldown   = var.cpu_autoscale_in_cooldown
    scale_out_cooldown  = var.cpu_autoscale_out_cooldown
  }
}
