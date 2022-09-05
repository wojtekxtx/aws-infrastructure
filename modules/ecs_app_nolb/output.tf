output "app_role" {
  value = module.ecs_task.app_role
}

output "ecs_service" {
  value = aws_ecs_service.this
}

output "log_group" {
  value = module.ecs_task.log_group
}
