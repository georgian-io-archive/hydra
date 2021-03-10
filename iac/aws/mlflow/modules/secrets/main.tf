resource "random_string" "rds_username" {
  length  = var.username_length
  special = false
}

resource "random_password" "rds_password" {
  length  = var.password_length
  special = false
}

resource "aws_secretsmanager_secret" "admin_username" {
  name                    =  var.username_secret_name
  recovery_window_in_days = var.username_recovery_window
}

resource "aws_secretsmanager_secret_version" "secret_username" {
  secret_id     = aws_secretsmanager_secret.admin_username.id
  secret_string = "mlflow${random_string.rds_username.result}"
}

resource "aws_secretsmanager_secret" "admin_password" {
  name                    = var.password_secret_name
  recovery_window_in_days = var.password_recovery_window
}

resource "aws_secretsmanager_secret_version" "secret_password" {
  secret_id     = aws_secretsmanager_secret.admin_password.id
  secret_string = random_password.rds_password.result
}