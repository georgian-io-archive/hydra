resource "aws_ecs_cluster" "mlflow_server_cluster" {
  name = var.mlflow_server_cluster
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
      },
      "secrets" : [
        {
          "name" : "USERNAME",
          "valueFrom" : "${aws_secretsmanager_secret.admin_username.arn}"
        },
        {
          "name" : "PASSWORD",
          "valueFrom" : "${aws_secretsmanager_secret.admin_password.arn}"
        }
      ],
      "environment" : [
        {
          "name" : "BUCKET",
          "value" : "hydra-mlflow-artifact-store"
        },
        {
          "name" : "FOLDER",
          "value" : "logging"
        },
        {
          "name" : "DBNAME",
          "value" : "${aws_db_instance.mlflowdb_tf_test.name}"
        },
        {
          "name" : "HOST",
          "value" : "${aws_db_instance.mlflowdb_tf_test.address}"
        },
        {
          "name" : "PORT",
          "value" : "3306"
        }
      ]
    }
  ]
  DEFINITION
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  memory                    = 1024
  cpu                       = 512
  task_role_arn             = aws_iam_role.hydra_mlflow_ecs_tasks.arn
  execution_role_arn        = aws_iam_role.hydra_mlflow_ecs_tasks.arn
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
    subnets           = [var.public_subnet_a]
    security_groups   = [aws_security_group.mlflow_sg.id]
    assign_public_ip  = true
  }
}