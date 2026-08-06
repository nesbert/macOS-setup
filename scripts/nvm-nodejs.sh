#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

HOME="${HOME:-$(eval echo ~${SUDO_USER:-$USER})}"

source "$HOME/.zshrc"

export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

if ! command -v brew >/dev/null 2>&1; then
  echo "⛔️ Homebrew is required before installing Node.js with nvm." >&2
  exit 1
fi

if ! brew list --formula nvm >/dev/null 2>&1; then
  echo "ℹ️ Installing nvm with Homebrew..."
  brew install nvm
fi

NVM_SCRIPT="$(brew --prefix nvm)/nvm.sh"

if [[ ! -f "$NVM_SCRIPT" ]]; then
  echo "⛔️ Missing nvm loader: $NVM_SCRIPT" >&2
  echo "⛔️ Install nvm with Homebrew before running this script." >&2
  exit 1
fi

# shellcheck source=/dev/null
. "$NVM_SCRIPT"

echo "ℹ️ Installing Node.js with nvm..."
nvm install node
nvm alias default node
nvm use default
