#!/usr/bin/env bash

trim_line() {
  local line="$1"

  line="${line%%#*}"
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"

  printf '%s\n' "${line}"
}

print_package_list_source() {
  local package_type="$1"
  local list_path="$2"

  echo "Installing ${package_type} from ${list_path}..."
}

install_brew_packages_from_list() {
  local package_type="$1"
  local brew_args="$2"
  local list_path="$3"
  local package=""

  if [[ ! -f "${list_path}" ]]; then
    echo "Missing package list: ${list_path}" >&2
    return 1
  fi

  print_package_list_source "${package_type}" "${list_path}"

  while IFS= read -r package || [[ -n "${package}" ]]; do
    package="$(trim_line "${package}")"

    [[ -n "${package}" ]] || continue

    brew install ${brew_args} "${package}"
  done < "${list_path}"
}
