output "app_role" {
  value = module.ecs_task.app_role
}

output "dns_record" {
  value = aws_route53_record.this
}
