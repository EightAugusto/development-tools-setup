#!/bin/bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/../util.sh
source ${BASE_PATH}/../../.env

# Verify if the script is runned as root
if is_not_root; then log ERROR "This script should be runned as root"; exit 1; fi

# Define and validate required variables
APPLICATION_NAME="$(get_app_name ${BASE_PATH})"
APPLICATION_VERSION="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} VERSION)"
APPLICATION_INSTALL_PATH="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} INSTALL_PATH)"
if [ -z ${APPLICATION_VERSION} ]; then log ERROR "Invalid APPLICATION_VERSION for '${APPLICATION_NAME}'"; exit 1; fi
if [ -z ${APPLICATION_INSTALL_PATH} ]; then log ERROR "Invalid APPLICATION_INSTALL_PATH for '${APPLICATION_NAME}'"; exit 1; fi

# Get the OS_ARCH string based on "arch"
case $(arch) in
  "x86_64") OS_ARCH="amd64";;
	"aarch64") OS_ARCH="arm64";;
  "arm64") OS_ARCH="arm64";;
  *) log ERROR "Unsupported architecture '$(arch)'"; exit 1;;
esac;

# Get OS Type
if is_mac_os; then OS_TYPE="darwin"; else OS_TYPE="linux"; fi

# Download installer and verify checksum
log INFO "Installing '${APPLICATION_NAME}:${APPLICATION_VERSION}' in '${APPLICATION_INSTALL_PATH}' for '${OS_TYPE}' and architecture '${OS_ARCH}'"
rm -rf ${APPLICATION_INSTALL_PATH}
mkdir -p ${APPLICATION_INSTALL_PATH}
COMPRESSED_FILE_NAME="go${APPLICATION_VERSION}.${OS_TYPE}-${OS_ARCH}.tar.gz"
curl --silent --output ${APPLICATION_INSTALL_PATH}/${COMPRESSED_FILE_NAME} https://dl.google.com/go/${COMPRESSED_FILE_NAME}
curl --silent --output ${APPLICATION_INSTALL_PATH}/${COMPRESSED_FILE_NAME}.sha256 https://dl.google.com/go/${COMPRESSED_FILE_NAME}.sha256
cd ${APPLICATION_INSTALL_PATH}
echo "$(cat ${COMPRESSED_FILE_NAME}.sha256) ${COMPRESSED_FILE_NAME}" | sha256sum --quiet --strict --check -
rm ${COMPRESSED_FILE_NAME}.sha256
cd --

# Extract binary
tar --extract --file ${APPLICATION_INSTALL_PATH}/${COMPRESSED_FILE_NAME} --directory ${APPLICATION_INSTALL_PATH} --strip-components 1 --no-same-owner
rm ${APPLICATION_INSTALL_PATH}/${COMPRESSED_FILE_NAME}
log INFO "Installed '${APPLICATION_NAME}:${APPLICATION_VERSION}' in '${APPLICATION_INSTALL_PATH}' for '${OS_TYPE}' and architecture '${OS_ARCH}'"
