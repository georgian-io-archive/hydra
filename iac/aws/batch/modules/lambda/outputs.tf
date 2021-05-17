output "lambda_invocation_response" {
  description = "Output of the invoked lambda function initiating batch database"
  value       = jsondecode(data.aws_lambda_invocation.db_init.result)
}