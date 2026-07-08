#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./lib/brew-package-helpers.sh
source "${SCRIPT_DIR}/lib/brew-package-helpers.sh"

BREW_CASKS_FILE="${BREW_CASKS_FILE:-${REPO_ROOT}/config/brew-casks.txt}"

install_brew_packages_from_list "Homebrew casks" "--cask" "${BREW_CASKS_FILE}"
