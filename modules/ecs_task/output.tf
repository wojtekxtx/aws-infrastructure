output "task_def" {
  value = aws_ecs_task_definition.this
}

output "app_role" {
  value = aws_iam_role.app
}
