resource "aws_s3_bucket" "mlflow_artifact_store" {
  bucket  = var.mlflow_artifact_store
  acl     = "private"
}

resource "aws_db_instance" "mlflowdb_tf_test" {
  identifier              = "mlflowdbtftest"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  name                    = "mlflowdb"
  username                = aws_secretsmanager_secret_version.secret_username.secret_string
  password                = aws_secretsmanager_secret_version.secret_password.secret_string
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.mlflow_sg.id]
  parameter_group_name    = "default.mysql5.7"
  skip_final_snapshot     = true
}

//resource "aws_db_instance" "mlflowdb" {
//  allocated_storage       = 20
//  storage_type            = "gp2"
//  engine                  = "mysql"
//  engine_version          = "5.7"
//  instance_class          = "db.t2.micro"
//  name                    = "mlflowdb"
//  username                = var.db_username
//  password                = "3982ryu923hudsflw47SADSA32"
//  db_subnet_group_name    = aws_db_subnet_group.default.name
//  vpc_security_group_ids  = [aws_security_group.mlflow_sg.id]
//  parameter_group_name    = "default.mysql5.7"
//  skip_final_snapshot     = true
//}