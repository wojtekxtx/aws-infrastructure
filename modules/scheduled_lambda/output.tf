output "iam_role" {
  value = aws_iam_role.this
}

output "log_group" {
  value = aws_cloudwatch_log_group.this
}

output "lambda_function" {
  value = aws_lambda_function.this
}
