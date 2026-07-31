#!/usr/bin/env bash

run_script() {
  local script_name="$1"
  shift

  "${SCRIPTS_DIR}/${script_name}" "$@"
}

setup_dotfiles_repo() {
  if [[ -d "${DOTFILES_DIR}/.git" ]]; then
    echo "ℹ️ Updating dotfiles repo in ${DOTFILES_DIR}..."
    git -C "${DOTFILES_DIR}" pull --ff-only
  else
    echo "ℹ️ Cloning dotfiles repo from ${DOTFILES_REPO_URL}..."
    mkdir -p "$(dirname "${DOTFILES_DIR}")"
    git clone "${DOTFILES_REPO_URL}" "${DOTFILES_DIR}"
  fi
}

use_default_if_missing() {
  local candidate_path="$1"
  local default_path="$2"

  if [[ -f "${candidate_path}" ]]; then
    printf '%s\n' "${candidate_path}"
  else
    printf '%s\n' "${default_path}"
  fi
}

resolve_existing_path() {
  local path="$1"

  [[ -e "${path}" || -L "${path}" ]] || return 1

  /usr/bin/perl -MCwd=abs_path -e 'my $path = shift; my $resolved = abs_path($path); exit 1 unless defined $resolved; print $resolved;' "${path}"
}

backup_and_link() {
  local source_path="$1"
  local target_path="$2"
  local resolved_source_path=""
  local resolved_target_path=""

  if [[ ! -e "${source_path}" && ! -L "${source_path}" ]]; then
    echo "ℹ️ Skipping missing dotfile source: ${source_path}"
    return 0
  fi

  resolved_source_path="$(resolve_existing_path "${source_path}")"
  resolved_target_path="$(resolve_existing_path "${target_path}" || true)"

  if [[ -n "${resolved_target_path}" ]] && [[ "${resolved_target_path}" == "${resolved_source_path}" ]]; then
    echo "ℹ️ Link already configured: ${target_path}"
    return 0
  fi

  if [[ -e "${target_path}" || -L "${target_path}" ]]; then
    mv "${target_path}" "${target_path}.${MACOS_SETUP_START_TIME}.bak"
    echo "ℹ️ Backed up ${target_path} to ${target_path}.${MACOS_SETUP_START_TIME}.bak"
  fi

  ln -s "${source_path}" "${target_path}"
  echo "ℹ️ Linked ${target_path} -> ${source_path}"
}
