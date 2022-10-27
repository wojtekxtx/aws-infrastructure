output "group" {
  value = var.group
}

output "secrets" {
  value     = aws_ssm_parameter.this
  sensitive = true
}

output "ignored_value_secrets" {
  value     = aws_ssm_parameter.ignored_values
  sensitive = true
}

output "hash" {
  value     = md5(join("", concat([for k in data.aws_ssm_parameter.ignored_values : k.value], [for k in aws_ssm_parameter.this : k.value])))
  sensitive = false
}
