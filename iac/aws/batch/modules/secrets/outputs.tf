output "username" {
   value        = aws_secretsmanager_secret_version.secret_username.secret_string
   description  = "Randomly generated username"
}

output "password" {
   value        = aws_secretsmanager_secret_version.secret_password.secret_string
   description  = "Randomly generated password"
}