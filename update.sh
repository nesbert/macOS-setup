#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

if test $(which brew); then
  echo "Updating Homebrew..."
  brew update
  brew upgrade
fi

if [[ -d "${HOME}/.oh-my-zsh" ]]; then
  echo "Updating Oh My ZSH..."
  "${HOME}/.oh-my-zsh"/tools/upgrade.sh
fi

if [[ -d ~/.vim_runtime ]]; then
  echo "Updating Ultimate Vim configuration..."
  mv ~/.vim_runtime/my_configs.vim /tmp
  rm -rf ~/.vim_runtime
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh
  mv /tmp/my_configs.vim ~/.vim_runtime
fi
