variable "name" {
  type = string
}

variable "environment" {
  type        = string
  description = "Environment name (test, dev etc)"
}

variable "containers" {
  type = list(object({
    name        = string
    image_repo  = any
    image_tag   = string
    ports       = list(number)
    environment = map(string)
    command     = list(string)
  }))
}

variable "cpu" {
  type        = number
  description = "Number of CPU units. 1024 is 1 vCPU"
  default     = 512
}

variable "memory" {
  type        = number
  description = "Memory limit for the container (in MiB)"
  default     = 512
}
