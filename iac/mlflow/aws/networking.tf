resource "aws_db_subnet_group" "default" {
  name        = var.rds_subnet_group_name
  subnet_ids  = [var.public_subnet_a, var.private_subnet_b]
}

//resource "aws_vpc" "mlflow_vpc" {
//  cidr_block = "192.168.0.0/16"
//
//  tags = {
//    Name = "mlflow_tracking"
//  }
//}
//
//resource "aws_subnet" "mlflow_subnet_a" {
//  vpc_id            = aws_vpc.mlflow_vpc.id
//  cidr_block        = "192.168.0.0/24"
//  availability_zone = "us-east-1a"
//}
//
//resource "aws_subnet" "mlflow_subnet_b" {
//  vpc_id            = aws_vpc.mlflow_vpc.id
//  cidr_block        = "192.168.0.0/24"
//  availability_zone = "us-east-1b"
//}
