resource "aws_ssm_parameter" "this" {
  for_each = var.secrets
  name     = "/${lower(var.group)}/${lower(each.key)}"
  type     = "SecureString"
  value    = each.value
  key_id   = var.kms_alias
}

resource "aws_ssm_parameter" "ignored_values" {
  for_each = toset(var.ignored_value_secrets)
  name     = "/${lower(var.group)}/${lower(each.key)}"
  type     = "SecureString"
  value    = "change_me"
  key_id   = var.kms_alias
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}
