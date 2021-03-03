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
      "image" : "${var.docker_image}",
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
          "valueFrom" : "${var.admin_username_arn}"
        },
        {
          "name" : "PASSWORD",
          "valueFrom" : "${var.admin_password_arn}"
        }
      ],
      "environment" : [
        {
          "name" : "BUCKET",
          "value" : "${var.s3_bucket_name}"
        },
        {
          "name" : "FOLDER",
          "value" : "${var.s3_bucket_folder}"
        },
        {
          "name" : "DBNAME",
          "value" : "${var.db_name}"
        },
        {
          "name" : "HOST",
          "value" : "${var.db_host}"
        },
        {
          "name" : "PORT",
          "value" : "${var.db_port}"
        }
      ]
    }
  ]
  DEFINITION
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  memory                    = var.task_memory
  cpu                       = var.task_cpu
  task_role_arn             = var.task_role_arn
  execution_role_arn        = var.execution_role_arn
}

resource "aws_ecs_service" "service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.mlflow_server_cluster.id
  task_definition = aws_ecs_task_definition.mlflow_ecs_task_definition.arn
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.aws_lb_target_group_arn
    container_name = var.container_name
    container_port = 5000
  }

  network_configuration {
    subnets           = var.ecs_service_subnets
    security_groups   = var.ecs_service_security_groups
    assign_public_ip  = true
  }
}