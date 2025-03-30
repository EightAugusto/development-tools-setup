#!/bin/bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../util.sh
source ${BASE_PATH}/../../.env

# Verify if the script is runned as root
if is_not_root; then log ERROR "This script should be runned as root"; exit 1; fi

# Define varsion and install path
APPLICATION_NAME="$(get_app_name ${BASE_PATH})"
APPLICATION_VERSION="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} VERSION)"
APPLICATION_INSTALL_PATH="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} INSTALL_PATH)"
if [ -z ${APPLICATION_VERSION} ]; then log ERROR "Invalid APPLICATION_VERSION for '${APPLICATION_NAME}'"; exit 1; fi
if [ -z ${APPLICATION_INSTALL_PATH} ]; then log ERROR "Invalid APPLICATION_INSTALL_PATH for '${APPLICATION_NAME}'"; exit 1; fi

# Custom application variables
APPLICATION_INSTALL_PATH="${APPLICATION_INSTALL_PATH}/gradle-${APPLICATION_VERSION}"

# Download installer and verify checksum
log INFO "Installing '${APPLICATION_NAME}:${APPLICATION_VERSION}' in '${APPLICATION_INSTALL_PATH}'"
rm -rf ${APPLICATION_INSTALL_PATH}
mkdir -p ${APPLICATION_INSTALL_PATH}
COMPRESSED_FILE_NAME="gradle-${APPLICATION_VERSION}-bin.zip"
curl --silent --output ${APPLICATION_INSTALL_PATH}/../${COMPRESSED_FILE_NAME} --location --remote-name --url https://services.gradle.org/distributions/${COMPRESSED_FILE_NAME}
curl --silent --output ${APPLICATION_INSTALL_PATH}/../${COMPRESSED_FILE_NAME}.sha256 --location --remote-name --url https://services.gradle.org/distributions/${COMPRESSED_FILE_NAME}.sha256
cd ${APPLICATION_INSTALL_PATH}/..
echo "$(cat ${COMPRESSED_FILE_NAME}.sha256) ${COMPRESSED_FILE_NAME}" | sha256sum --quiet --strict --check -
rm ${COMPRESSED_FILE_NAME}.sha256
cd --

# Extract binary
unzip -qq ${APPLICATION_INSTALL_PATH}/../${COMPRESSED_FILE_NAME} -d ${APPLICATION_INSTALL_PATH}/..
rm ${APPLICATION_INSTALL_PATH}/../${COMPRESSED_FILE_NAME}
log INFO "Installed '${APPLICATION_NAME}:${APPLICATION_VERSION}' in '${APPLICATION_INSTALL_PATH}'"
