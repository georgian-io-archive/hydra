output "compute_environment_service_role_arn" {
   value        = aws_iam_role.compute_environment_service_role.arn
   description  = "ARN of IAM role of the compute environment service role"
}

output "compute_environment_instance_profile_arn" {
   value        = aws_iam_instance_profile.compute_environment_instance_profile.arn
   description  = "ARN of the IAM compute environment instance profile"
}

output "lambda_service_role_arn" {
   value        = aws_iam_role.lambda_service_role.arn
   description  = "ARN of the IAM lambda function service role"
}