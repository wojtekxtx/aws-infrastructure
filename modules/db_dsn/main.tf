resource "random_password" "this" {
  length      = 32
  special     = false
  lower       = true
  upper       = true
  numeric     = true
  min_lower   = 2
  min_numeric = 2
  min_special = 0
  min_upper   = 2
}
