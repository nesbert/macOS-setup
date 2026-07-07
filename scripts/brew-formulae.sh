#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./lib/brew-package-list.sh
source "${SCRIPT_DIR}/lib/brew-package-list.sh"

BREW_FORMULAE_FILE="${BREW_FORMULAE_FILE:-${REPO_ROOT}/config/brew-formulae.txt}"

install_brew_packages_from_list "brew formulae" "" "${BREW_FORMULAE_FILE}"
