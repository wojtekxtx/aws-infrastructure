output "task_def" {
  value = aws_ecs_task_definition.this
}

output "app_role" {
  value = aws_iam_role.app
}

output "log_group" {
  value = aws_cloudwatch_log_group.this
}
