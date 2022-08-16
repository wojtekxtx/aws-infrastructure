locals {
  resource_name = "${var.name}_${var.environment}"
}

data "aws_region" "this" {
}

data "aws_caller_identity" "this" {
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "${aws_cloudwatch_log_group.this.arn}:*",
    ]
  }
  statement {
    actions = [
      "ssm:Get*",
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:parameter/${var.env_vars.CHAMBER_SECRET_GROUP}/*"
    ]
  }
  statement {
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      var.kms_key.arn,
    ]
  }
}

resource "aws_iam_role" "this" {
  name               = local.resource_name
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_policy" "this" {
  name   = local.resource_name
  policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${local.resource_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "this" {
  function_name = local.resource_name
  role          = aws_iam_role.this.arn
  s3_bucket     = var.s3obj.bucket
  s3_key        = var.s3obj.key
  runtime       = var.runtime
  handler       = var.handler
  memory_size   = var.memory
  timeout       = var.timeout
  environment {
    variables = var.env_vars
  }
  depends_on = [
    aws_iam_role_policy_attachment.this,
    aws_cloudwatch_log_group.this,
  ]
}

resource "aws_cloudwatch_event_rule" "this" {
  name                = local.resource_name
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "lambda"
  arn       = aws_lambda_function.this.arn
  depends_on = [
    aws_lambda_function.this,
  ]
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}
