output "https_listener" {
  value = aws_alb_listener.https
}

output "load_balancer" {
  value = aws_lb.this
}
