# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "mlflow_artifact_store" {
  bucket  = var.mlflow_artifact_store
  acl     = "private"
}

resource "aws_ecs_cluster" "mlflow_server_cluster" {
  name = var.mlflow_server_cluster
}

resource "aws_ecr_repository" "mlflow_container_repository" {
  name = var.mlflow_container_repository

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_cloudwatch_log_group" "mlflow_ecs_task_log_group" {
  name = var.cloudwatch_log_group
}



resource "aws_ecs_task_definition" "mlflow_ecs_task_definition" {
  family                = var.mlflow_ecs_task_family
  container_definitions = <<DEFINITION
  [
    {
      "name" : "${var.container_name}",
      "image" : "${aws_ecr_repository.mlflow_container_repository.repository_url}:latest",
      "essential" : true,
      "memory" : 1024,
      "cpu" : 256,
      "portMappings" : [
        {
          "containerPort" : 5000,
          "hostPort" : 5000,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.mlflow_ecs_task_log_group.name}",
          "awslogs-region" : "${var.aws_region}",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ]
  DEFINITION
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  memory                    = 2048
  cpu                       = 1024
  task_role_arn             = aws_iam_role.hydra_mlflow_ecs_tasks.arn
  execution_role_arn        = aws_iam_role.hydra_mlflow_ecs_tasks.arn
}

resource "aws_iam_role" "hydra_mlflow_ecs_tasks" {
  name                = var.mlflow_ecs_tasks_role
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRolePolicy" {
  role        = aws_iam_role.hydra_mlflow_ecs_tasks.name
  count       = length(var.ecs_task_iam_policy_arn)
  policy_arn  = var.ecs_task_iam_policy_arn[count.index]
}

resource "aws_security_group" "mlflow_sg" {
  name    = var.mlflow_sg
  vpc_id  = var.vpc_id

  ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

  ingress {
    from_port         = 5000
    to_port           = 5000
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

  ingress {
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name        = var.rds_subnet_group_name
  subnet_ids  = ["subnet-9d2ccbfa", "subnet-6510d04b"]
}

resource "aws_db_instance" "mlflowdb" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  name                    = "mlflowdb"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.mlflow_sg.id]
  parameter_group_name    = "default.mysql5.7"
  skip_final_snapshot     = true
}

resource "aws_lb" "hydra_mlflow_lb" {
  name                = var.alb_name
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.mlflow_sg.id]
  subnets             = ["subnet-6139fa4f", "subnet-9d2ccbfa"]

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

resource "aws_ecs_service" "service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.mlflow_server_cluster.id
  task_definition = aws_ecs_task_definition.mlflow_ecs_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name = var.container_name
    container_port = 5000
  }

  network_configuration {
    subnets           = ["subnet-9d2ccbfa"]
    security_groups   = [aws_security_group.mlflow_sg.id]
    assign_public_ip  = true
  }
}

resource "aws_appautoscaling_target" "ecs_autoscaling_target" {
  max_capacity = 3
  min_capacity = 2
  resource_id = "service/${aws_ecs_cluster.mlflow_server_cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_memory_autoscaling_policy" {
  name = "memory-autoscale-mlflow"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_autoscaling_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_cpu_autoscaling_policy" {
  name = "cpu-autoscale-mlflow"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_autoscaling_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80
  }
}



# add load balancer
# add autoscaling policy