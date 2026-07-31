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

  echo "ℹ️ Installing ${package_type} from ${list_path}..."
}

validate_brew_cask_conflict_policy() {
  case "${BREW_CASK_CONFLICT_POLICY:-fail}" in
    fail|force|skip)
      ;;
    *)
      echo "Invalid BREW_CASK_CONFLICT_POLICY: ${BREW_CASK_CONFLICT_POLICY}. Expected fail, force, or skip." >&2
      return 1
      ;;
  esac
}

brew_install_package() {
  local brew_args="$1"
  local package="$2"
  local conflict_policy="${3:-fail}"

  if [[ "${brew_args}" != "--cask" ]]; then
    if [[ -n "${brew_args}" ]]; then
      brew install "${brew_args}" "${package}"
    else
      brew install "${package}"
    fi
    return 0
  fi

  case "${conflict_policy}" in
    fail)
      brew install --cask "${package}"
      ;;
    force)
      brew install --cask --force "${package}"
      ;;
    skip)
      if ! brew install --cask "${package}"; then
        echo "⚠️ Skipping cask ${package} because install failed under BREW_CASK_CONFLICT_POLICY=skip." >&2
        return 2
      fi
      ;;
  esac
}

install_brew_packages_from_list() {
  local package_type="$1"
  local brew_args="$2"
  local list_path="$3"
  local package=""
  local cask_conflict_policy="${BREW_CASK_CONFLICT_POLICY:-fail}"
  local -a skipped_packages=()

  if [[ ! -f "${list_path}" ]]; then
    echo "⚠️ Missing package list: ${list_path}" >&2
    return 1
  fi

  if [[ "${brew_args}" == "--cask" ]]; then
    validate_brew_cask_conflict_policy
    echo "ℹ️ Using BREW_CASK_CONFLICT_POLICY=${cask_conflict_policy}."
  fi

  print_package_list_source "${package_type}" "${list_path}"

  while IFS= read -r package || [[ -n "${package}" ]]; do
    package="$(trim_line "${package}")"

    [[ -n "${package}" ]] || continue

    if ! brew_install_package "${brew_args}" "${package}" "${cask_conflict_policy}"; then
      if [[ "${brew_args}" == "--cask" ]] && [[ "${cask_conflict_policy}" == "skip" ]]; then
        skipped_packages+=("${package}")
        continue
      fi

      return 1
    fi
  done < "${list_path}"

  if [[ ${#skipped_packages[@]} -gt 0 ]]; then
    echo "Skipped ${#skipped_packages[@]} cask(s) under BREW_CASK_CONFLICT_POLICY=skip:" >&2
    printf '  - %s\n' "${skipped_packages[@]}" >&2
  fi
}
