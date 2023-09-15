#!/usr/bin/env bash
#
# shellcheck disable=SC1091,SC2155

readonly __FILE__="$(readlink -f "${0}")"
readonly __DIR__="$(dirname "${__FILE__}")"
readonly PROG="hr4sh"

source "${__DIR__}/lib.sh"

usage() {
  cat <<-EOF
usage: ${PROG} [-h] [-l INT] [-o STR] [-i CHAR] [-p] [title]

positional arguments:
  title     title to insert in center

options:
  -h,       show this help message and exit
  -l INT,   total character length (default: 80)
  -o STR,   outer character(s) (default: #)
  -i CHAR,  inner character (default: -)
  -p,       as paragraph, BEGIN and END
EOF
}

main() {
  local -i length=80
  local outer="#"
  local inner="-"
  local as_paragraph="false"

  while getopts "hl:o:i:p" opt; do
    case "${opt}" in
    h)
      usage
      exit
      ;;
    l)
      if [[ ! "${OPTARG}" =~ ^[0-9]+$ ]]; then
        echo "${PROG}: length must be an integer, is '${OPTARG}'" >&2
        exit 1
      fi
      length="${OPTARG}"
      ;;
    o)
      outer="${OPTARG}"
      ;;
    i)
      inner="${OPTARG:0:1}"
      ;;
    p)
      as_paragraph="true"
      ;;
    *)
      usage
      exit 1
      ;;
    esac
  done
  shift $((OPTIND - 1))
  local title="${1}"

  if [[ "${as_paragraph}" == "true" ]]; then
    lib::print_paragraph "${length}" "${outer}" "${inner}" "${title}"
  elif [[ -n "${title}" ]]; then
    lib::print_titled "${length}" "${outer}" "${inner}" "${title}"
  else
    lib::print_untitled "${length}" "${outer}" "${inner}"
  fi
}

main "$@"
