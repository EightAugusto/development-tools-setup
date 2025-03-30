#!/bin/bash

function log() {
  printf "%s - %s [%+3s] - %s\n" "$(date '+%Y-%m-%d %H:%M:%S')"  "$(realpath ${0})" "${1}" "${2}"
}

function get_app_name {
  if [ -z ${1} ]; then log ERROR "Function should be called using the pattern: 'get_app_name <base_path>'"; exit 1; fi
  # Get he app name based on the current folder script
  echo "${1##*/}"
}

function get_var_by_app_name_and_postfix {
  if [[ -z ${1} || -z ${2} ]]; then log ERROR "Function should be called using the pattern 'get_var_by_app_name_and_postfix <app_name> <postfix>'"; exit 1; fi
  # Get the variable name and get the value based on it
  VARIABLE_NAME=$(printf "$(echo "${1}_${2}" | awk '{print toupper($0)}')")
  echo ${!VARIABLE_NAME}
}

function is_not_root {
  # Verify if current EUID is not root (0)
  if [ "${EUID}" -ne 0 ]; then return 0; else return 1; fi
}

function is_not_linux_os {
  # If "uname" is not "Linux" is not Linux
  if [ $(uname) != "Linux" ]; then return 0; else return 1; fi
}

function is_mac_os {
  # If "uname" is "Darwin" is MacOS
  if [ $(uname) == "Darwin" ]; then return 0; else return 1; fi
}