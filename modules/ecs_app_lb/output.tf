output "app_role" {
  value = module.ecs_task.app_role
}

output "dns_record" {
  value = aws_route53_record.this
}

output "ecs_service" {
  value = aws_ecs_service.this
}

output "target_group" {
  value = aws_alb_target_group.this
}

output "log_group" {
  value = module.ecs_task.log_group
}
