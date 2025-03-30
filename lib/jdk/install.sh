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

# Custom application variables
APPLICATION_MAYOR_VERSION="${APPLICATION_VERSION%%.*}"

# Get the OS_ARCH string based on "arch"
case $(arch) in
  "x86_64") OS_ARCH="x64";;
	"aarch64") OS_ARCH="aarch64";;
  "arm64") OS_ARCH="aarch64";;
  *) log ERROR "Unsupported architecture '$(arch)'"; exit 1;;
esac;


# Get OS Type
if is_mac_os; then
  OS_TYPE="macos";
  APPLICATION_INSTALL_PATH="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} ${OS_TYPE}_INSTALL_PATH)"
else
  OS_TYPE="linux";
  APPLICATION_INSTALL_PATH="$(get_var_by_app_name_and_postfix ${APPLICATION_NAME} ${OS_TYPE}_INSTALL_PATH)/jdk-${APPLICATION_VERSION}.jdk"
fi
# Get the install path based on the OS_TYPE
if [ -z ${APPLICATION_INSTALL_PATH} ]; then log ERROR "Invalid APPLICATION_INSTALL_PATH for '${APPLICATION_NAME}'"; exit 1; fi

# Download installer and verify checksum
log INFO "Installing '${APPLICATION_NAME}:${APPLICATION_VERSION}' in '${APPLICATION_INSTALL_PATH}' for '${OS_TYPE}' and architecture '${OS_ARCH}'"
mkdir -p ${APPLICATION_INSTALL_PATH}
COMPRESSED_FILE_NAME="jdk-${APPLICATION_VERSION}_${OS_TYPE}-${OS_ARCH}_bin.tar.gz"
curl --silent --output ${APPLICATION_INSTALL_PATH}/${COMPRESSED_FILE_NAME} https://download.oracle.com/java/${APPLICATION_MAYOR_VERSION}/archive/${COMPRESSED_FILE_NAME}
curl --silent --output ${APPLICATION_INSTALL_PATH}/${COMPRESSED_FILE_NAME}.sha256 https://download.oracle.com/java/${APPLICATION_MAYOR_VERSION}/archive/${COMPRESSED_FILE_NAME}.sha256
cd ${APPLICATION_INSTALL_PATH}
echo "$(cat ${COMPRESSED_FILE_NAME}.sha256) ${COMPRESSED_FILE_NAME}" | sha256sum --quiet --strict --check -
rm ${COMPRESSED_FILE_NAME}.sha256
cd --

# Extract binary
tar --extract --file ${APPLICATION_INSTALL_PATH}/${COMPRESSED_FILE_NAME} --directory ${APPLICATION_INSTALL_PATH} --strip-components 1 --no-same-owner
rm ${APPLICATION_INSTALL_PATH}/${COMPRESSED_FILE_NAME}
log INFO "Installed '${APPLICATION_NAME}:${APPLICATION_VERSION}' in '${APPLICATION_INSTALL_PATH}' for '${OS_TYPE}' and architecture '${OS_ARCH}'"
