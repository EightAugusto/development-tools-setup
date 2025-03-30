#!/bin/bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../util.sh
source ${BASE_PATH}/../../.env

# Verify if the script is runned as root
if is_not_root; then log ERROR "This script should be runned as root"; exit 1; fi

# Define and validate required variables
APPLICATION_NAME="$(get_app_name ${BASE_PATH})"
APPLICATION_INSTALL_PATH="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} INSTALL_PATH)"
if [ -z ${APPLICATION_INSTALL_PATH} ]; then log ERROR "Invalid APPLICATION_INSTALL_PATH for '${APPLICATION_NAME}'"; exit 1; fi

# Verify if application is installed
APPLICATION_FOLDER_NAME="$(ls ${APPLICATION_INSTALL_PATH} | grep ${APPLICATION_NAME} | head)"
if [[ -z ${APPLICATION_FOLDER_NAME} ]]; then log ERROR "'${APPLICATION_NAME}' was not found"; exit 1; fi

# Delete the install path
log INFO "Removing '${APPLICATION_NAME}' from install path '${APPLICATION_INSTALL_PATH}/${APPLICATION_FOLDER_NAME}'"
rm -rf ${APPLICATION_INSTALL_PATH}/${APPLICATION_FOLDER_NAME}
log INFO "Removed '${APPLICATION_NAME}' from install path '${APPLICATION_INSTALL_PATH}/${APPLICATION_FOLDER_NAME}'"