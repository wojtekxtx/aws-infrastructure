variable "chamber_secret_group_name" {
  description = "Secrets group used in Chamber"
}
variable "kms_key_arn" {
  description = "ARN of KMS key used to encrypt the secrets"
}
variable "roles" {
  type = set(string)
}
