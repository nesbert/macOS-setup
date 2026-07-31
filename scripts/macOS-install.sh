#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCRIPTS_DIR="${REPO_ROOT}/scripts"
HOME="${HOME:-$(eval echo ~${SUDO_USER:-$USER})}"

# local vars
MACOS_SETUP_START_TIME=$(date +%Y%m%d%H%M%S)
HOME_ZPROFILE="$HOME/.zprofile"
UNAME_MACHINE="$(/usr/bin/uname -m)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Code/github.com/nesbert/macOS-dotfiles}"
DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-https://github.com/nesbert/macOS-dotfiles.git}"
LOCAL_CONFIG_DIR="${LOCAL_CONFIG_DIR:-${REPO_ROOT}/config.local}"
BREW_FORMULAE_FILE="${BREW_FORMULAE_FILE:-${LOCAL_CONFIG_DIR}/brew-formulae.txt}"
BREW_CASKS_FILE="${BREW_CASKS_FILE:-${LOCAL_CONFIG_DIR}/brew-casks.txt}"
BREW_JDKS_FILE="${BREW_JDKS_FILE:-${LOCAL_CONFIG_DIR}/brew-jdks.txt}"

# shellcheck source=./lib/macOS-install-helpers.sh
source "${SCRIPT_DIR}/lib/macOS-install-helpers.sh"

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

# Clone dotfiles repo early so package selections can come from dotfiles.
setup_dotfiles_repo

# Link configurations
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/.config" "$HOME/.config"
source "$HOME/.zshrc"

BREW_FORMULAE_FILE="$(use_default_if_missing "${BREW_FORMULAE_FILE}" "${REPO_ROOT}/config/brew-formulae.txt")"
BREW_CASKS_FILE="$(use_default_if_missing "${BREW_CASKS_FILE}" "${REPO_ROOT}/config/brew-casks.txt")"
BREW_JDKS_FILE="$(use_default_if_missing "${BREW_JDKS_FILE}" "${REPO_ROOT}/config/brew-jdks.txt")"

# Install brew & cask apps
run_script brew-formulae.sh "$BREW_FORMULAE_FILE"
run_script brew-casks.sh "$BREW_CASKS_FILE"
run_script brew-jdks.sh "$BREW_JDKS_FILE"

# Install NodeJS with nvm
run_script nvm-nodejs.sh

# Install The Ultimate vimrc
run_script vim-settings.sh install

# Setup DX-focused macOS system settings
run_script macOS-system-settings.sh

# Setup personal macOS preferences
# run_script macOS-personal-settings.sh

echo "Install complete."
echo "Open a new Ghostty or zsh session to load your updated shell configuration."
