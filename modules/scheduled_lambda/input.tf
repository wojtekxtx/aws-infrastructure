variable "env_vars" {
  type = map(string)
}

variable "runtime" {
  type    = string
  default = "python3.9"
}

variable "memory" {
  type    = number
  default = 128
}

variable "schedule_expression" {
  type    = string
  default = "rate(1 day)"
}

variable "s3obj" {}
variable "handler" {}
variable "name" {}
variable "environment" {}
variable "kms_key" {}

variable "timeout" {
  type    = number
  default = 60
}
