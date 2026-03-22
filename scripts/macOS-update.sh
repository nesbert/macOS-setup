#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCRIPTS_DIR="${REPO_ROOT}/scripts"

if command -v brew >/dev/null 2>&1; then
  echo "Updating Homebrew..."
  brew update
  brew upgrade
fi

# Update The Ultimate vimrc
"${SCRIPTS_DIR}/vim-settings.sh" update
