resource "tls_private_key" "server_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "main" {
  name       = "server-access-ssh"
  public_key = tls_private_key.server_key.public_key_openssh
}

# Optional passable SSH key
data "hcloud_ssh_key" "provided" {
  count = var.ssh_sideload_name != null ? 1 : 0

  name = var.ssh_sideload_name
}