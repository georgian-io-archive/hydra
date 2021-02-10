# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mlflowdb"
  username             = "<ENTER YOUR USERNAME HERE>"
  password             = "<ENTER YOUR PASSWORD HERE>"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_s3_bucket" "default" {
  bucket = "terraform-3289094859043859340853"
  acl    = "private"
}

resource "aws_ecs_cluster" "cluster-23423432423113" {
    name = "cluster-23423432423113"
}