# shellcheck shell=bash disable=SC2155

lib::_repeat() {
  local str="${1}"
  local -i len="${2}"

  printf "%${len}s" | tr " " "${str}"
}

lib::print_paragraph() {
  local -i length="${1}"
  local outer="${2}"
  local inner="${3}"
  local title="${4}"

  if [[ -z "${title}" ]]; then
    local begin="BEGIN"
    local end="END"
  else
    local begin="BEGIN ${title}"
    local end="END ${title}"
  fi

  lib::print_titled "${length}" "${outer}" "${inner}" "${begin}"
  lib::print_titled "${length}" "${outer}" "${inner}" "${end}"
}

lib::print_titled() {
  local -i length="${1}"
  local outer="${2}"
  local inner="${3}"
  local title="${4}"

  local -i spare_len=$((length - "${#outer}" * 2 - "${#title}" - 4))
  if [[ "${spare_len}" -lt 2 ]]; then
    echo "Length insufficient, $((2 - spare_len)) more required." >&2
    exit 1
  fi
  local -i rspare_len=$((spare_len / 2))
  local -i lspare_len=$((spare_len - rspare_len))

  echo \
    "${outer}" \
    "$(lib::_repeat "${inner}" "${lspare_len}")" \
    "${title}" \
    "$(lib::_repeat "${inner}" "${rspare_len}")" \
    "${outer}"
}

lib::print_untitled() {
  local -i length="${1}"
  local outer="${2}"
  local inner="${3}"

  local -i spare_len=$((length - "${#outer}" * 2 - 2))
  if [[ "${spare_len}" -lt 1 ]]; then
    echo "Length insufficient, $((1 - spare_len)) more required." >&2
    exit 1
  fi

  echo "${outer} $(lib::_repeat "${inner}" "${spare_len}") ${outer}"
}
