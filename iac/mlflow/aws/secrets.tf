resource "random_string" "rds_username" {
  length  = 20
  special = false
}

resource "random_password" "rds_password" {
  length  = 20
  special = true
}

resource "aws_secretsmanager_secret" "admin_username" {
  name                    = "test/mlflow/tf/admin_username"
  description             = "RDS Admin Username"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_username" {
  secret_id     = aws_secretsmanager_secret.admin_username.id
  secret_string = random_string.rds_username.result
}

resource "aws_secretsmanager_secret" "admin_password" {
  name                    = "test/mlflow/tf/admin_password"
  description             = "RDS Admin Password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_password" {
  secret_id     = aws_secretsmanager_secret.admin_password.id
  secret_string = random_password.rds_password.result
}