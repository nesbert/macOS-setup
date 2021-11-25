#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

echo "Updating & Upgrading Homebrew..."
brew update
brew upgrade

if [[ -d ~/.vim_runtime ]]; then
  echo "Updating Ultimate Vim configuration..."
  mv ~/.vim_runtime/my_configs.vim /tmp
  rm -rf ~/.vim_runtime
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh
  mv /tmp/my_configs.vim ~/.vim_runtime
fi
