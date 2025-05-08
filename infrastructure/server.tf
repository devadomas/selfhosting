resource "hcloud_server" "server" {
  name        = "server"
  image       = "debian-12"
  server_type = var.server_type
  backups     = var.server_backups_enabled

  public_net {
    ipv4         = hcloud_primary_ip.server_primary_ip.id
    ipv6_enabled = false
    # IPv6 disabled
  }

  datacenter   = var.server_datacenter
  firewall_ids = [hcloud_firewall.fw.id]
  ssh_keys = flatten([
    [hcloud_ssh_key.main.id],
    var.ssh_sideload_name != null ? [data.hcloud_ssh_key.provided[0].id] : []
  ])

  connection {
    host        = hcloud_primary_ip.server_primary_ip.ip_address
    user        = "root"
    type        = "ssh"
    agent       = true
    timeout     = "3m"
    private_key = tls_private_key.server_key.private_key_openssh
  }

  # Walkaround for remote-exec's flaw of not accepting environment variables
  provisioner "remote-exec" {
    inline = ["timedatectl set-timezone ${var.server_timezone}"]
  }

  # Server init script updates server, installs docker, schedules unassisted upgrades, outputs log to /var/log/server-init.log
  provisioner "remote-exec" {
    script = "${path.module}/scripts/init.sh"
  }
}

resource "null_resource" "provision_containers" {
  connection {
    host        = hcloud_primary_ip.server_primary_ip.ip_address
    user        = "root"
    type        = "ssh"
    agent       = true
    timeout     = "3m"
    private_key = tls_private_key.server_key.private_key_openssh
  }

  # Environment for docker compose
  provisioner "file" {
    content     = local.env_file
    destination = "/srv/.env"
  }

  # Copy latest manifests to server
  provisioner "file" {
    source      = "${path.module}/../manifests/"
    destination = "/srv"
  }

  # Refresh docker
  provisioner "remote-exec" {
    inline = [
      "cd /srv",
      "docker compose down",
      "docker compose --env-file .env up -d"
    ]
  }

  triggers = {
    manifest_hash = local.manifest_content_hash
    env_hash      = local.env_content_hash
  }

  depends_on = [hcloud_server.server]
}