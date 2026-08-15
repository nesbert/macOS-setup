#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck source=./lib/brew-package-helpers.sh
source "${SCRIPT_DIR}/lib/brew-package-helpers.sh"

BREW_JDKS_FILE="${1:-${REPO_ROOT}/config/brew-jdks.txt}"

install_brew_packages_from_list "Homebrew JDK casks" "--cask" "${BREW_JDKS_FILE}"

cat << EOF
Please add JDKs using jEnv, for example get list of install JDKs...

  /usr/libexec/java_home -V
  jenv add <your_jdk_path>

Other helpful commands...

  jenv version
  jenv versions
  jenv global 21
  jenv local 1.8

Visit https://www.jenv.be for more information.
EOF
