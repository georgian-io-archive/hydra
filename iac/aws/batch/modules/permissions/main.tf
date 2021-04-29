
resource "aws_security_group" "hydrabatch_sg" {
  name    = var.hydrabatch_sg
  vpc_id  = var.vpc_id

  ingress {
    from_port         = 0
    to_port           = 3306
    protocol          = "tcp"
    cidr_blocks       = var.cidr_blocks
  }

  ingress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    self              = true
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }
}
