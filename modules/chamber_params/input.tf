variable "group" {
  type = string
  validation {
    condition     = length(var.group) != 0
    error_message = "Group can't be empty."
  }
}

variable "secrets" {
  description = "key value pairs of secrets"
  type        = map(string)
  default     = {}
}

variable "kms_alias" {
  type        = string
  description = "kms key alias"
  validation {
    condition     = length(var.kms_alias) != 0
    error_message = "KMS alias can't be empty."
  }
}

variable "ignored_value_secrets" {
  description = "List of parameters, that values are ignored. Will be created/destroyed."
  type        = list(string)
  default     = []
}
