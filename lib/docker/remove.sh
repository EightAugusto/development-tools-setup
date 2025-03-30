#!/bin/bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../util.sh

# Verify if the script is runned as root and in Linux
if is_not_root; then log ERROR "This script should be runned as root"; exit 1; fi
if is_not_linux_os; then log ERROR "The script should be runned in Linux"; exit 1; fi

# Verify command is not installed
if [ ! $(command -v docker) ]; then log ERROR "Docker is not installed"; exit 1; fi

# Remove all docker data
log INFO "Removing all docker data"
docker stop $(docker ps -qa)
docker rm $(docker ps -qa)
docker rmi -f $(docker images -qa )
docker volume rm $(docker volume ls -qf)
docker network rm $(docker network ls -q)

# Stop docker service
log INFO "Stoping docker service"
systemctl stop docker

# Remove dependencies and repository
log INFO "Removing docker dependencies"
yum remove yum-utils docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
rm -rf /etc/yum.repos.d/docker-ce.repo

# Enable and start docker service
log INFO "Disabling docker services"
systemctl disable docker
systemctl deamon-reload

# Remove user from docker group
log INFO "Remove user from docker group"
gpasswd --delete docker ${SUDO_USER:-${USER}}

# Remove docker configuration and storage
log INFO "Remove docker configuration and storage"
rm -rf /etc/docker /var/lib/docker /opt/containerd