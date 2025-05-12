locals {
  cloud_config = <<EOT
  #cloud-config

  package_update: true
  package_upgrade: true

  timezone: ${var.server_timezone}

  apt:
    sources:
      docker.list:
        source: deb [arch=arm64] https://download.docker.com/linux/debian $RELEASE stable
        keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

  packages:
    - curl
    - ca-certificates
    - docker-ce
    - docker-ce-cli
    - containerd.io
    - docker-buildx-plugin
    - docker-compose-plugin

  write_files:
    - path: /etc/apt/apt.conf.d/55unattended-upgrades-local
      content: |
        Unattended-Upgrade::Automatic-Reboot "true";
        Unattended-Upgrade::Automatic-Reboot-Time "02:00";
  EOT

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
  VW_BACKUP_ACCESS_KEY_ID=${var.vaultwarden_backup_access_key_id}
  VW_BACKUP_SECRET_ACCESS_KEY=${var.vaultwarden_backup_secret_access_key}
  VW_BACKUP_ENDPOINT=${var.vaultwarden_backup_endpoint}
  VW_BACKUP_BUCKET=${var.vaultwarden_backup_bucket}
  VW_BACKUP_PASSWORD=${var.vaultwarden_backup_password}
  WG_PASSWORD_HASH=${var.wireguard_password_hash}
  EOT
  env_content_hash = sha256(local.env_file)

  manifest_files        = fileset(path.module, "../manifests/**/*")
  manifest_content_hash = sha256(join("", [for file in local.manifest_files : file(file)]))
}