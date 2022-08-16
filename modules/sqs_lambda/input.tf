variable "runtime" {
  default = "python3.9"
}

variable "memory" {
  type    = number
  default = 128
}

variable "environment" {
  type = string
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "handler" {
}

variable "name" {
}

variable "sqs_env_name" {
}

variable "s3obj" {
  description = "S3 resource object with ZIP"
}

variable "kms_key" {
  description = "KMS key used to encrypt secrets"
}

variable "timeout" {
  type    = number
  default = 60
}
