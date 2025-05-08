#!/bin/bash
{
  echo "======Updating system======"

  sudo apt-get update
  echo "System updated"

  # Docker install
  echo "======Installing docker======"

  echo "Adding Dockers official GPG keys"
  sudo apt-get install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo "Adding repository to APT sources"
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  echo "Installing Docker and Docker Compose"
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  echo "Docker installed"

  # Configure unattended upgrades
  echo "======Configuring Unattended Upgrades======"

  echo "Unattended-Upgrade::Automatic-Reboot \"true\";" >> /etc/apt/apt.conf.d/55unattended-upgrades-local
  echo "Unattended-Upgrade::Automatic-Reboot-Time \"02:00\";" >> /etc/apt/apt.conf.d/55unattended-upgrades-local
  echo "Unattended upgrades configured for 02:00"

  # Create a directory for server files
  echo "======Creating a directory for server files======"
  
  mkdir /srv
  echo "Directory created"

} 2>&1 | tee /var/log/server-init.log