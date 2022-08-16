output "dsn" {
  value = "postgresql://${var.username}:${random_password.this.result}@${var.hostname}:${var.port}/${var.dbname}"
}

output "password" {
  value = random_password.this.result
}
