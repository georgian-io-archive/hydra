output "lb_target_group_arn" {
  value       = aws_lb_target_group.target_group.arn
  description = "ARN of Load Balancer target group"
}