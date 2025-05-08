output "vwarden_url" {
  description = "Base URL for Vaultwarden"
  value       = "${random_string.vwarden_subdomain.result}.${var.base_domain}"
}