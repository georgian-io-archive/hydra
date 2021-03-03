resource "aws_lb" "mlflow_lb" {
  name                = var.lb_name
  internal            = false
  load_balancer_type  = "application"
  security_groups     = var.lb_security_groups
  subnets             = var.lb_subnets

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target_group" {
  name          = var.lb_target_group
  port          = 80
  protocol      = "HTTP"
  target_type   = "ip"
  vpc_id        = var.vpc_id

  depends_on = [aws_lb.mlflow_lb]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.mlflow_lb.arn
  port = 80

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
