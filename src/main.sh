#!/usr/bin/env bash
#
# shellcheck disable=SC1091,SC2155,SC2181

readonly __FILE__="$(readlink -f "${0}")"
readonly __DIR__="$(dirname "${__FILE__}")"

source "${__DIR__}/lib.sh"

readonly PROG="hr4sh"
BASH_ARGV0="${PROG}"
readonly USAGE="usage: ${PROG} [-h] [-p] [-i STR] [-l INT] [-o STR] [title]"
readonly HELP="\
${USAGE}

positional arguments:
  title               title to insert in center

options:
  -h, --help          show this help message and exit
  -p, --as-paragraph  print two horizontal rules, BEGIN and END

style proprties:
  -i, --inner STR     inner character (default: -)
  -l, --length INT    total character length (default: 80)
  -o, --outer STR     outer character(s) (default: #)\
"
declare -A args=(
  ["as_paragraph"]="false"
  ["inner"]="-"
  ["length"]=80
  ["outer"]="#"
  ["title"]=""
)

parse_args() {
  while getopts "hpi:l:o:" opt; do
    case "${opt}" in
    h)
      echo "${HELP}"
      exit
      ;;
    l)
      if [[ ! "${OPTARG}" =~ ^[0-9]+$ ]]; then
        printf '%s\n%s\n' "${PROG}: invalid int value '${OPTARG}' -- l" "${USAGE}" >&2
        exit 1
      fi
      args["length"]="${OPTARG}"
      ;;
    o)
      args["outer"]="${OPTARG}"
      ;;
    i)
      args["inner"]="${OPTARG:0:1}"
      ;;
    p)
      args["as_paragraph"]="true"
      ;;
    ?)
      echo "${USAGE}"
      exit 1
      ;;
    esac
  done
  shift $((OPTIND - 1))
  args["title"]="${1}"
}

main() {
  parse_args "$@"
  if [[ "${args[as_paragraph]}" == "true" ]]; then
    lib::print_as_paragraph "${args[length]}" "${args[outer]}" "${args[inner]}" "${args[title]}"
  elif [[ -n "${args["title"]}" ]]; then
    lib::print_titled "${args[length]}" "${args[outer]}" "${args[inner]}" "${args[title]}"
  else
    lib::print_untitled "${args[length]}" "${args[outer]}" "${args[inner]}"
  fi
  if [[ "$?" -ne 0 ]]; then
    exit 1
  fi
}

main "$@"
