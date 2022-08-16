variable "runtime" {
  default = "python3.9"
}

variable "memory" {
  type    = number
  default = 128
}

variable "handler" {
  description = "Handler to execute"
}

variable "environment" {
  type = string
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "name" {
  description = "lambda name"
}

variable "s3obj" {
  description = "S3 resource object with ZIP"
}

variable "kms_key" {
  description = "KMS key used to encrypt secrets"
}

variable "zone" {
  description = "route 53 zone object"
}

variable "load_balancer" {
  description = "aws_lb object"
}

variable "listener" {
  description = "aws_alb_listener object"
}
