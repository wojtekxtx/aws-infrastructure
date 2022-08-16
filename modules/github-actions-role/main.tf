data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        # With branch name
        # "repo:octo-org/octo-repo:ref:refs/heads/octo-branch"
        "repo:${var.org}/${var.repo}:*",
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.org}_${var.repo}"
  path               = "/github-actions/"
  assume_role_policy = data.aws_iam_policy_document.this.json
}
