data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_region" "this" {
}

data "aws_caller_identity" "this" {
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:GetQueueUrl",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [aws_sqs_queue.this.arn]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["${aws_cloudwatch_log_group.this.arn}:*"]
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
      var.kms_key.arn
    ]
  }
}

data "aws_iam_policy_document" "caller" {
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [aws_sqs_queue.this.arn]
  }
}

resource "aws_iam_user" "caller" {
  name = "${local.name}_caller"
}

resource "aws_iam_access_key" "caller" {
  user = aws_iam_user.caller.name
}

resource "aws_iam_policy" "caller" {
  name   = "${local.name}_caller"
  policy = data.aws_iam_policy_document.caller.json
}

resource "aws_iam_user_policy_attachment" "caller" {
  user       = aws_iam_user.caller.name
  policy_arn = aws_iam_policy.caller.arn
}

resource "aws_iam_role" "this" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_policy" "this" {
  name   = local.name
  policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
