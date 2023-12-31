#!/bin/bash

set -eu -o pipefail

CWD_PARSE_OPTIONS="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
PARSE_OPTIONS=$(basename "${BASH_SOURCE[0]}" .sh)

source "${CWD_PARSE_OPTIONS}/print.sh"

declare -A OPTIONS
while [[ $# -gt 0 ]]; do
  if [ -z "${1:-}" ]; then
    shift
    continue
  fi

  if [ -n "${1:-}" ] && [[ $1 = -* ]]; then
    OPTIONS[$1]=""
  fi

  if [ -n "${2:-}" ] && [[ $2 != -* ]]; then
    OPTIONS[$1]="$2"
    shift
  fi

  shift
done

retrochamber.lib.print.debug "${PARSE_OPTIONS}" "Option keys: ${!OPTIONS[*]}"
retrochamber.lib.print.debug "${PARSE_OPTIONS}" "Option values: ${OPTIONS[*]}"

retrochamber.lib.options.indexExists () {
  local INDEX=${1}

  if [ -v 'OPTIONS[$INDEX]' ]; then
    echo 1 && return
  fi

  echo 0 && return
}

retrochamber.lib.options.get () {
  local INDEX=${1}

  if [[ $(retrochamber.lib.options.indexExists "${INDEX}") -eq 0 ]]; then
    return
  fi

  echo "${OPTIONS[${INDEX}]}"
}

retrochamber.lib.options.set () {
  local INDEX=${1}
  local VALUE=${2:-}

  OPTIONS[${INDEX}]="${VALUE}"
}

retrochamber.lib.options.remove () {
  local INDEX=${1}

  if [[ $(retrochamber.lib.options.indexExists "${INDEX}") -eq 0 ]]; then
    return
  fi

  unset "OPTIONS[${INDEX}]"
}
