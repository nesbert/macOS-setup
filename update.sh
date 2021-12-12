#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

if test $(which brew); then
  echo "Updating Homebrew..."
  brew update
  brew upgrade
fi

# Update The Ultimate vimrc
./templates/vim.sh update

if [[ -d "${HOME}/.oh-my-zsh" ]]; then
  echo "Updating Oh My ZSH..."
  "${HOME}/.oh-my-zsh"/tools/upgrade.sh
fi
