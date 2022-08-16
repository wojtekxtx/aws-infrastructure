output "sqs_queue" {
  value = aws_sqs_queue.this
}

output "sqs_env_map" {
  value = { (var.sqs_env_name) = aws_sqs_queue.this.arn }
}
