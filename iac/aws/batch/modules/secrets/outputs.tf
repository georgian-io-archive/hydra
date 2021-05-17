output "username_secret" {
   value        = aws_secretsmanager_secret.admin_username.name
   description  = "Secret name of username of RDS instance"
}

output "username" {
   value        = aws_secretsmanager_secret_version.secret_username.secret_string
   description  = "Randomly generated username"
}

output "password_secret" {
   value        = aws_secretsmanager_secret.admin_password.name
   description  = "Secret name of password of RDS instance"
}

output "password" {
   value        = aws_secretsmanager_secret_version.secret_password.secret_string
   description  = "Randomly generated password"
}