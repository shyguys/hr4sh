# shellcheck shell=bash
# shellcheck disable=SC2155

lib::repeat() {
  local str="${1}"
  local -i len="${2}"

  printf "%${len}s" | tr " " "${str}"
}

lib::print_as_paragraph() {
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

  local -i spare_length=$((length - "${#outer}" * 2 - "${#title}" - 4))
  if [[ "${spare_length}" -lt 2 ]]; then
    echo "[ERROR] length insufficient, $((2 - spare_length)) more required" >&2
    return 1
  fi
  local -i right_spare_length=$((spare_length / 2))
  local -i left_spare_length=$((spare_length - right_spare_length))

  echo \
    "${outer}" \
    "$(lib::repeat "${inner}" "${left_spare_length}")" \
    "${title}" \
    "$(lib::repeat "${inner}" "${right_spare_length}")" \
    "${outer}"
}

lib::print_untitled() {
  local -i length="${1}"
  local outer="${2}"
  local inner="${3}"

  local -i spare_length=$((length - "${#outer}" * 2 - 2))
  if [[ "${spare_length}" -lt 1 ]]; then
    echo "[ERROR] length insufficient, $((1 - spare_length)) more required" >&2
    return 1
  fi

  echo "${outer} $(lib::repeat "${inner}" "${spare_length}") ${outer}"
}
