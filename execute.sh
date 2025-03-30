#!/bin/bash
BASE_PATH="$(cd -- "$(dirname "${0}")" > /dev/null 2>&1; pwd -P)"
source ${BASE_PATH}/lib/util.sh

# Verify if both arguments are part of the call
EXECUTION_TYPE=${1}
EXECUTION_TARGET=${2}
if [[ -z ${EXECUTION_TYPE} || -z ${EXECUTION_TARGET} ]]; then log ERROR "Script should be executed as 'sh instal.sh <type> <target>'"; exit 1; fi

# Execute the file based on the arguments
EXECUTION_FILE="${BASE_PATH}/lib/${EXECUTION_TARGET}/${EXECUTION_TYPE}.sh"
if [ ! -f ${EXECUTION_FILE} ]; then log ERROR "'${EXECUTION_TYPE}' for '${EXECUTION_TARGET}' commands not found"; exit 1; fi

sh ${EXECUTION_FILE}