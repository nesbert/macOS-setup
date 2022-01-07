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

# Update zsh-autosuggestions
if [[ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
  echo "Updating zsh-autosuggestions..."
  rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Update zsh-syntax-highlighting
if [[ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
  echo "Updating zsh-syntax-highlighting..."
  rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

