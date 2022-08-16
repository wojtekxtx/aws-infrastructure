variable "desired_replica_count" {
  type        = number
  description = "How many container replicas should be online?"
  default     = 2
}

variable "ecs" {
  description = "ECS config"
}

variable "vpc_id" {
  description = "VPC ID where service will be located"
  type        = string
}
