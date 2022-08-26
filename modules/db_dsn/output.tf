output "dsn" {
  value = "${var.schema}://${var.username}:${random_password.this.result}@${var.hostname}:${var.port}/${var.dbname}"
}

output "password" {
  value = random_password.this.result
}
