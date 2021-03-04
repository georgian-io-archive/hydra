output "username" {
   value        = aws_secretsmanager_secret_version.secret_username.secret_string
   description  = "Randomly generated username"
}

output "username_arn" {
   value        = aws_secretsmanager_secret.admin_username.arn
   description  = "ARN of username secret"
}

output "password" {
   value        = aws_secretsmanager_secret_version.secret_password.secret_string
   description  = "Randomly generated password"
}

output "password_arn" {
   value        = aws_secretsmanager_secret.admin_password.arn
   description  = "ARN of password secret"
}