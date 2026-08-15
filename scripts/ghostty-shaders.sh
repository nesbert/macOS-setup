#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

HOME="${HOME:-$(eval echo ~${SUDO_USER:-$USER})}"
GHOSTTY_SHADER_ROOT="${GHOSTTY_SHADER_ROOT:-${HOME}/Code/github.com}"
DOTFILES_DIR="${DOTFILES_DIR:-${GHOSTTY_SHADER_ROOT}/nesbert/macOS-dotfiles}"
GHOSTTY_CONFIG_DIR="${DOTFILES_DIR}/.config/ghostty"

clone_or_update() {
  local repository_url="$1"
  local repository_path="$2"

  if [[ -d "${repository_path}/.git" ]]; then
    echo "ℹ️ Updating shader repository in ${repository_path}..."
    git -C "${repository_path}" pull --ff-only
    return 0
  fi

  if [[ -e "${repository_path}" || -L "${repository_path}" ]]; then
    echo "⛔️ Cannot clone ${repository_url}: path exists and is not a Git repository: ${repository_path}" >&2
    return 1
  fi

  echo "ℹ️ Cloning ${repository_url} into ${repository_path}..."
  mkdir -p "$(dirname "${repository_path}")"
  git clone "${repository_url}" "${repository_path}"
}

ensure_symlink() {
  local link_path="$1"
  local target_path="$2"

  if [[ -L "${link_path}" ]] && [[ "$(readlink "${link_path}")" == "${target_path}" ]]; then
    echo "ℹ️ Link already configured: ${link_path}"
    return 0
  fi

  if [[ -e "${link_path}" || -L "${link_path}" ]]; then
    echo "⛔️ Refusing to replace existing path: ${link_path}" >&2
    return 1
  fi

  ln -s "${target_path}" "${link_path}"
  echo "ℹ️ Linked ${link_path} -> ${target_path}"
}

main() {
  local shaders_0xhckr="${GHOSTTY_SHADER_ROOT}/0xhckr/ghostty-shaders"
  local shaders_krone="${GHOSTTY_SHADER_ROOT}/KroneCorylus/ghostty-shader-playground"
  local shaders_linkarzu="${GHOSTTY_SHADER_ROOT}/linkarzu/dotfiles-latest"

  [[ -d "${DOTFILES_DIR}/.git" ]] || {
    echo "⛔️ Dotfiles repository not found: ${DOTFILES_DIR}" >&2
    echo "⛔️ Clone macOS-dotfiles or set DOTFILES_DIR before running this command." >&2
    exit 1
  }

  clone_or_update "https://github.com/0xhckr/ghostty-shaders.git" "${shaders_0xhckr}"
  clone_or_update "https://github.com/KroneCorylus/ghostty-shader-playground.git" "${shaders_krone}"
  clone_or_update "https://github.com/linkarzu/dotfiles-latest.git" "${shaders_linkarzu}"

  mkdir -p "${GHOSTTY_CONFIG_DIR}"
  ensure_symlink "${GHOSTTY_CONFIG_DIR}/shaders-0xhckr" "${shaders_0xhckr}"
  ensure_symlink "${GHOSTTY_CONFIG_DIR}/shaders-KroneCorylus" "${shaders_krone}/public/shaders"
  ensure_symlink "${GHOSTTY_CONFIG_DIR}/shaders-linkarzu" "${shaders_linkarzu}/ghostty/shaders"
}

main "$@"
