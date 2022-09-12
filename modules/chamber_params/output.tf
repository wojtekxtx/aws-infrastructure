output "group" {
  value = var.group
}

output "secrets" {
  value = aws_ssm_parameter.this
}

output "ignored_value_secrets" {
  value = aws_ssm_parameter.ignored_values
}
