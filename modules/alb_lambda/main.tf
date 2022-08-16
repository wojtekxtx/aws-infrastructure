locals {
  resource_prefix = "${var.name}-${var.environment}"
  fqdn            = "${var.name}-${var.environment}.${var.zone.name}"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${local.resource_prefix}"
  retention_in_days = 14
}

resource "aws_lambda_function" "this" {
  function_name = local.resource_prefix
  role          = aws_iam_role.this.arn
  s3_bucket     = var.s3obj.bucket
  s3_key        = var.s3obj.key
  runtime       = var.runtime
  handler       = var.handler
  memory_size   = var.memory
  timeout       = 60
  environment {
    variables = merge(
      var.env_vars,
    )
  }
  depends_on = [
    aws_iam_role_policy_attachment.this,
    aws_cloudwatch_log_group.this,
  ]
}

resource "aws_lb_target_group" "this" {
  name        = local.resource_prefix
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_lambda_function.this.arn
  depends_on       = [aws_lambda_permission.this]
}

resource "aws_route53_record" "this" {
  zone_id = var.zone.id
  name    = local.fqdn
  type    = "A"
  alias {
    name                   = var.load_balancer.dns_name
    zone_id                = var.load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = [local.fqdn]
    }
  }
}
