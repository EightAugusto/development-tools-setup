#!/bin/bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../util.sh

# Verify if the script is runned as root and in Linux
if is_not_root; then log ERROR "This script should be runned as root"; exit 1; fi
if is_not_linux_os; then log ERROR "The script should be runned in Linux"; exit 1; fi

# Verify command is already installed
if [ $(command -v docker) ]; then log ERROR "Docker already is installed"; exit 1; fi

# Add dependencies and repository
log INFO "Installing docker dependencies"
yum install yum-utils -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Enable and start docker service
log INFO "Enabling docker services"
systemctl enable docker
systemctl start docker

log INFO "Adding permision to docker for the current user"
usermod -aG docker ${SUDO_USER:-${USER}}
chown ${SUDO_USER:-${USER}} /var/run/docker.sock
systemctl restart docker