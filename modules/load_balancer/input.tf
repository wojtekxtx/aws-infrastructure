variable "subnet_ids" {
  type = set(string)
}

variable "security_group_ids" {
  type = set(string)
}

variable "name" {
  type = string
}

variable "cert_arn" {
  type = string
}
