data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


data "aws_iam_policy_document" "read_secrets_group_policy_document" {
  statement {
    sid = "SSMGetParameters"

    actions = [
      "ssm:Get*",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.chamber_secret_group_name}/*"
    ]
  }

  statement {
    sid = "KMSDecrypt"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      var.kms_key_arn
    ]
  }
}

resource "aws_iam_policy" "read_secrets" {
  name   = "Read-secrets-group-${var.chamber_secret_group_name}"
  policy = data.aws_iam_policy_document.read_secrets_group_policy_document.json
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(var.roles)
  role       = each.key
  policy_arn = aws_iam_policy.read_secrets.id
}
