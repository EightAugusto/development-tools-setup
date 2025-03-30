#!/bin/bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../util.sh
source ${BASE_PATH}/../../.env

# Verify if the script is runned as root and in Linux
if is_not_root; then log ERROR "This script should be runned as root"; exit 1; fi
if is_not_linux_os; then log ERROR "The script should be runned in Linux"; exit 1; fi

# Verify command is not installed
if [ ! $(command -v minikube) ]; then log ERROR "Minikube is not installed"; exit 1; fi

# Define and validate required variables
APPLICATION_NAME="$(get_app_name ${BASE_PATH})"
APPLICATION_INSTALL_PATH="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} INSTALL_PATH)"
if [ -z ${APPLICATION_INSTALL_PATH} ]; then log ERROR "Invalid APPLICATION_INSTALL_PATH for '${APPLICATION_NAME}'"; exit 1; fi

# Delete the executable
log INFO "Removing '${APPLICATION_NAME}' from install path '${APPLICATION_INSTALL_PATH}'"
minikube delete --all --purge
rm ${APPLICATION_INSTALL_PATH}/minikube
log INFO "Removed '${APPLICATION_NAME}' from install path '${APPLICATION_INSTALL_PATH}'"
