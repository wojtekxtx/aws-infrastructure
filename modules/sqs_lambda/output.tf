output "sqs_queue" {
  value = aws_sqs_queue.this
}

output "sqs_env_map" {
  value = { (var.sqs_env_name) = aws_sqs_queue.this.arn }
}

output "log_group" {
  value = aws_cloudwatch_log_group.this
}

output "lambda_function" {
  value = aws_lambda_function.this
}
