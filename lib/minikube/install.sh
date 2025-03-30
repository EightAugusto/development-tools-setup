#!/bin/bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../util.sh
source ${BASE_PATH}/../../.env

# Verify if the script is runned as root and in Linux
if is_not_root; then log ERROR "This script should be runned as root"; exit 1; fi
if is_not_linux_os; then log ERROR "The script should be runned in Linux"; exit 1; fi

# Verify command is already installed
if [ $(command -v minikube) ]; then log ERROR "Minikube already is installed"; exit 1; fi

# Define and validate required variables
APPLICATION_NAME="$(get_app_name ${BASE_PATH})"
APPLICATION_VERSION="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} VERSION)"
APPLICATION_INSTALL_PATH="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} INSTALL_PATH)"
if [ -z ${APPLICATION_VERSION} ]; then log ERROR "Invalid APPLICATION_VERSION for '${APPLICATION_NAME}'"; exit 1; fi
if [ -z ${APPLICATION_INSTALL_PATH} ]; then log ERROR "Invalid APPLICATION_INSTALL_PATH for '${APPLICATION_NAME}'"; exit 1; fi

# Get the OS_ARCH string based on "arch"
case $(arch) in
  "x86_64") OS_ARCH="amd64";;
  "arm64") OS_ARCH="arm64";;
  *) log ERROR "Unsupported architecture '$(arch)'"; exit 1;;
esac;

log INFO "Installing '${APPLICATION_NAME}:${APPLICATION_VERSION}' in '${APPLICATION_INSTALL_PATH}' for architecture '${OS_ARCH}'"
EXECUTABLE_FILE_NAME="minikube-linux-${OS_ARCH}"
curl --silent --location --output ${EXECUTABLE_FILE_NAME} https://storage.googleapis.com/minikube/releases/v${APPLICATION_VERSION}/${EXECUTABLE_FILE_NAME}
install ${EXECUTABLE_FILE_NAME} ${APPLICATION_INSTALL_PATH}/minikube
rm ${EXECUTABLE_FILE_NAME}
log INFO "Installed '${APPLICATION_NAME}:${APPLICATION_VERSION}' in '${APPLICATION_INSTALL_PATH}' for architecture '${OS_ARCH}'"
