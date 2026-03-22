#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMPLATES_DIR="${REPO_ROOT}/templates"

# local vars
MACOS_SETUP_START_TIME=$(date +%Y%m%d%H%M%S)
HOME_ZPROFILE="$HOME/.zprofile"
UNAME_MACHINE="$(/usr/bin/uname -m)"
DOTFILES_DIR="${HOME}/Code/github.com/nesbert/macOS-dotfiles"
DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-https://github.com/nesbert/macOS-dotfiles.git}"

run_template() {
  local template_name="$1"
  shift

  "${TEMPLATES_DIR}/${template_name}" "$@"
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
    echo "Skipping missing dotfile source: ${source_path}"
    return 0
  fi

  resolved_source_path="$(resolve_existing_path "${source_path}")"
  resolved_target_path="$(resolve_existing_path "${target_path}" || true)"

  if [[ -n "${resolved_target_path}" ]] && [[ "${resolved_target_path}" == "${resolved_source_path}" ]]; then
    echo "Link already configured: ${target_path}"
    return 0
  fi

  if [[ -e "${target_path}" || -L "${target_path}" ]]; then
    mv "${target_path}" "${target_path}.${MACOS_SETUP_START_TIME}.bak"
    echo "Backed up ${target_path} to ${target_path}.${MACOS_SETUP_START_TIME}.bak"
  fi

  ln -s "${source_path}" "${target_path}"
  echo "Linked ${target_path} -> ${source_path}"
}

# find the CLI Tools update
echo "Checking for CLI Tool updates..."
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n') || true
# install CLIE Tools update
if [[ ! -z "$PROD" ]]; then
  softwareupdate -i "$PROD" --verbose
fi

# Check for Homebrew, install if not installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "Added Homebrew shell to ${HOME_ZPROFILE}."
  echo '# Add Homebrew support' >> "${HOME_ZPROFILE}"

  # load shellenv for Apple Silicon
  if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME_ZPROFILE}"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "${HOME_ZPROFILE}"
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # add autocomplete for brew
  echo 'FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"' >> "${HOME_ZPROFILE}"
fi

# Install brew & cask apps
run_template brew.sh
run_template brew-casks.sh
run_template brew-jdks.sh

# Install NodeJS with nvm
run_template nvm-nodejs.sh

# Install The Ultimate vimrc
run_template vim-settings.sh install

# Create workspace directories
mkdir -p "${HOME}/Code/github.com/nesbert"

# Setup macOS system settings
# run_template macOS-system-settings.sh

# Clone dotfiles repo and symlink .zshrc and .config
if [ -d "$DOTFILES_DIR/.git" ]; then
  echo "Updating dotfiles repo in ${DOTFILES_DIR}..."
  git -C "$DOTFILES_DIR" pull --ff-only
else
  echo "Cloning dotfiles repo from ${DOTFILES_REPO_URL}..."
  git clone "$DOTFILES_REPO_URL" "$DOTFILES_DIR"
fi

backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/.config" "$HOME/.config"

echo "Install complete."
echo "Open a new Ghostty or zsh session to load your updated shell configuration."
