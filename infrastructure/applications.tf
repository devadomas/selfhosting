resource "random_string" "vwarden_subdomain" {
  length  = 8
  special = false
  upper   = false
  # Only lowercase and numbers
}