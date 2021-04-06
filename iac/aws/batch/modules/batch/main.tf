data "aws_caller_identity" "current" {}

resource "aws_batch_compute_environment" "batch_compute_environment" {
  for_each                  = {for v in var.compute_environments: v.name => v.instance_type}

  compute_environment_name  = each.key

  compute_resources {
    instance_role       = var.compute_environment_instance_role
    instance_type       = [each.value]
    max_vcpus           = var.compute_environment_max_vcpus
    min_vcpus           = var.compute_environment_min_vcpus
    security_group_ids  = var.compute_environment_security_group_ids
    subnets             = var.compute_environment_subnets
    type                = var.compute_environment_resource_type
  }

  service_role              = var.compute_environment_service_role
  type                      = var.compute_environment_type
}

resource "aws_batch_job_queue" "batch_job_queue" {
  depends_on = [aws_batch_compute_environment.batch_compute_environment]

  for_each   = {for v in var.job_queues: v.name => "arn:aws:batch:${var.aws_region}:${data.aws_caller_identity.current.account_id}:compute-environment/${v.compute_environment}"}

  compute_environments      = [each.value]
  name                      = each.key
  priority                  = var.job_queue_priority
  state                     = var.job_queue_state
}