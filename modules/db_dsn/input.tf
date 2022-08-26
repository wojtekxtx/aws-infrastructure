variable "username" {
  type = string
  validation {
    condition     = length(var.username) != 0
    error_message = "Var username can't be empty."
  }
}

variable "port" {
  type    = number
  default = 5432
}

variable "hostname" {
  type = string
  validation {
    condition     = length(var.hostname) != 0
    error_message = "Hostname can't be empty."
  }
}

variable "dbname" {
  type = string
  validation {
    condition     = length(var.dbname) != 0
    error_message = "Var dbname can't be empty."
  }
}

variable "schema" {
  type    = string
  default = "postgresql"
  validation {
    condition     = contains(["postgresql", "postgresql+asyncpg"], var.schema)
    error_message = "Valid schema values are (postgresql, postgresql+asyncpg)."
  }
}
