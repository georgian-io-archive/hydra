# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "mlflowdb" {
  allocated_storage     = 20
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  name                  = "mlflowdb"
  username              = "sifjsdifjosfdson"
  password              = "3982ryu923hudsflw47SADSA32"
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
}

resource "aws_s3_bucket" "terraform_3289094859043859340853" {
  bucket  = "terraform-3289094859043859340853"
  acl     = "private"
}

resource "aws_ecs_cluster" "cluster_23423432423113" {
  name = "cluster_23423432423113"
}

resource "aws_ecs_task_definition" "task" {
  family = "task"
  container_definitions = <<DEFINITION
  [
    {
      "name" : "task",
      "image" : "823217009914.dkr.ecr.us-east-1.amazonaws.com/hydra-mlflow-server-aws:latest",
      "essential" : true,
      "memory" : 512,
      "cpu" : 256
    }
  ]
  DEFINITION
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  memory                    = 512
  cpu                       = 256
  execution_role_arn        = aws_iam_role.hydra_mlflow_ecs_tasks.arn
}

resource "aws_iam_role" "hydra_mlflow_ecs_tasks" {
  name                = "hydra_mlflow_ecs_tasks"
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
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ])

  role        = aws_iam_role.hydra_mlflow_ecs_tasks.name
  policy_arn  = each.value
}

resource "aws_ecs_service" "service" {
  name            = "service"
  cluster         = aws_ecs_cluster.cluster_23423432423113.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets = ["subnet-9d2ccbfa"]
    security_groups = ["sg-0fb24e7b891957130"]
    assign_public_ip = true
  }
}

resource "aws_security_group" "mlflow_sg" {
  name  = "mlflow-sg"
  vpc_id = "vpc-1d5f9e7b"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
