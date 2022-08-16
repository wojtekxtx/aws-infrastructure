variable "ssh_key_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  default = "t3.micro"
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}
