variable "db_name" {
  type = string
}

variable "rds_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "kms_alias" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t3.small"
}

variable "username" {
  type    = string
  default = "dbadmin"
}

variable "password" {
  type    = string
  default = null
}

variable "allocated_storage" {
  type    = number
  default = 5
}

variable "max_allocated_storage" {
  type    = number
  default = 5
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "iops" {
  type    = number
  default = 0
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "availability_zone" {
  type    = string
  default = null
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "pg_major" {
  type    = number
  default = 13
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "apply_immediately" {
  type    = bool
  default = false
}

variable "backup_window" {
  type    = string
  default = "02:00-05:00"
}

variable "maintenance_window" {
  type    = string
  default = "sun:02:00-sun:05:00"
}
