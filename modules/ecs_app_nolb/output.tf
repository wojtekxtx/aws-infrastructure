output "app_role" {
  value = module.ecs_task.app_role
}

output "ecs_service" {
  value = aws_ecs_service.this
}
