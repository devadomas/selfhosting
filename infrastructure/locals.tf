locals {
  env_file         = <<EOT
  TZ=${var.server_timezone}
  BASE_DOMAIN=${var.base_domain}
  ACME_EMAIL=acme@${var.base_domain}
  CF_API_EMAIL=${var.cloudflare_api_email}
  CF_API_KEY=${var.cloudflare_api_key}
  VW_SUBDOMAIN=${random_string.vwarden_subdomain.result}
  VW_ADMIN_TOKEN=${var.vaultwarden_admin_token}
  VW_PUSH_INSTALLATION_ID=${var.vaultwarden_installation_id}
  VW_PUSH_INSTALLATION_KEY=${var.vaultwarden_push_installation_key}
  VW_PUSH_RELAY_URI=${var.vaultwarden_push_relay_uri}
  VW_PUSH_IDENTITY_URI=${var.vaultwarden_push_identity_uri}
  WG_PASSWORD_HASH=${var.wireguard_password_hash}
  EOT
  env_content_hash = sha256(local.env_file)

  manifest_files        = fileset(path.module, "../manifests/**/*")
  manifest_content_hash = sha256(join("", [for file in local.manifest_files : file(file)]))
}