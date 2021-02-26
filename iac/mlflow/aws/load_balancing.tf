resource "aws_lb" "hydra_mlflow_lb" {
  name                = var.alb_name
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.mlflow_sg.id]
  subnets             = [var.public_subnet_a, var.public_subnet_b]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target_group" {
  name          = "ecs-mlflow-lb-tg"
  port          = 80
  protocol      = "HTTP"
  target_type   = "ip"
  vpc_id        = var.vpc_id

  depends_on = [aws_lb.hydra_mlflow_lb]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.hydra_mlflow_lb.arn
  port = 80

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
