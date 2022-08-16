locals {
  name = "${var.name}_${var.environment}"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${local.name}"
  retention_in_days = 14
}

resource "aws_sqs_queue" "this" {
  name                       = local.name
  visibility_timeout_seconds = 60
}

resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn = aws_sqs_queue.this.arn
  function_name    = aws_lambda_function.this.arn
  batch_size       = 1
  enabled          = true
}

resource "aws_lambda_function" "this" {
  function_name = local.name
  role          = aws_iam_role.this.arn
  s3_bucket     = var.s3obj.bucket
  s3_key        = var.s3obj.key
  runtime       = var.runtime
  handler       = var.handler
  memory_size   = var.memory
  timeout       = var.timeout
  environment {
    variables = merge(
      var.env_vars,
      { (var.sqs_env_name) = aws_sqs_queue.this.arn },
    )
  }
  depends_on = [
    aws_iam_role_policy_attachment.this,
    aws_cloudwatch_log_group.this,
    aws_sqs_queue.this,
  ]
}
