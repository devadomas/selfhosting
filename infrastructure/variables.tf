variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  sensitive   = true
}

variable "server_datacenter" {
  description = "Hetzner datacenter location"
}

variable "server_type" {
  description = "Server type for server instance"
  default     = "cax22"
}

variable "server_backups_enabled" {
  default = false
}

variable "server_timezone" {
  description = "Server timezone in Unix format that will be set during initialization"
  default     = "UTC"
}

variable "ssh_sideload_name" {
  description = "SSH key name that is already uploaded to HCloud"
  nullable    = true
}

variable "ssh_source_ips" {
  description = "Source IPs range for SSH access to server"
  sensitive   = true
  default     = []
  type        = list(string)
}


# Application related
variable "base_domain" {
  description = "Base domain for applications"
}

variable "cloudflare_api_email" {
  description = "Cloudflare API email for certificate generation via DNSChallenge"
}

variable "cloudflare_api_key" {
  description = "Cloudflare Host API key for certificate generation via DNSChallenge"
  sensitive   = true
}

# Vaultwarden configurational variables
variable "vaultwarden_admin_token" {
  description = "Vaultwarden admin token"
  default     = ""
}

variable "vaultwarden_installation_id" {
  description = "Vaultwarden Installation ID for push notifications"
  sensitive   = true
  default     = "" # optional
}

variable "vaultwarden_push_installation_key" {
  description = "Vaultwraden Installation Push Key for push notification"
  sensitive   = true
  default     = "" # optional
}

variable "vaultwarden_push_relay_uri" {
  default = "https://api.bitwarden.eu"
}

variable "vaultwarden_push_identity_uri" {
  default = "https://identity.bitwarden.eu"
}

# Vaultwarden backup configuration
variable "vaultwarden_backup_access_key_id" {
  description = "Vaultwarden backup S3 compatible bucket Access Key ID"
  type        = string
  sensitive   = true
}

variable "vaultwarden_backup_secret_access_key" {
  description = "Vaultwarden backup S3 compatible bucket Secret Access Key"
  type        = string
  sensitive   = true
}

variable "vaultwarden_backup_endpoint" {
  description = "Vaultwarden backup endpoint"
  type        = string
}

variable "vaultwarden_backup_bucket" {
  description = "Vaultwarden backup bucket"
  type        = string
}

variable "vaultwarden_backup_password" {
  description = "Vaultwarden backup archive password"
  type        = string
}

# Wireguard configuration
variable "wireguard_password_hash" {
  description = "Wireguard Password hash for admin panel"
  sensitive   = true
}