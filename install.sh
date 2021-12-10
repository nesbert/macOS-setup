#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# local vars
HOME_ZPROFILE="$HOME/.zprofile"
HOME_ZSHRC="$HOME/.zshrc"
UNAME_MACHINE="$(/usr/bin/uname -m)"

# find the CLI Tools update
echo "Checking for CLI Tool updates..."
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n') || true
# install CLIE Tools update
if [[ ! -z "$PROD" ]]; then
  softwareupdate -i "$PROD" --verbose
fi

# Check for Homebrew, install if not installed
if test ! $(which brew); then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "Added Homebrew shell to ${HOME_ZPROFILE}."
  echo '# Add Homebrew support' >> ${HOME_ZPROFILE}

  # load shellenv for Apple Silicon
  if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ${HOME_ZPROFILE}
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # add autocomplete for brew
  echo 'FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"' >> ${HOME_ZPROFILE}
fi

# List of packages
PACKAGES=(
  coreutils
  findutils
  gawk
  gh
  git
  grep
  gnu-sed
  gnu-tar
  gnu-indent
  gnu-which
  jq
  tree
  yamllint
  vim
  watch
  wget
  zsh
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

# Install vimrc
if [[ ! -d "${HOME}/.vim_runtime" ]]; then
  echo "Installing Ultimate Vim configuration..."
  git clone --depth=1 https://github.com/amix/vimrc.git ${HOME}/.vim_runtime
  sh ${HOME}/.vim_runtime/install_awesome_vimrc.sh

  if [[ ! -d "${HOME}/.vim/pack/themes/start/dracula" ]]; then
    mkdir -p ~/.vim/pack/themes/start
    git clone https://github.com/dracula/vim.git ${HOME}/.vim/pack/themes/start/dracula
  fi

  MY_CONFIG_VIM=${HOME}/.vim_runtime/my_configs.vim
  echo "set number" >> ${MY_CONFIG_VIM}
  echo 'packadd! dracula' >> ${MY_CONFIG_VIM}
  echo 'syntax enable' >> ${MY_CONFIG_VIM}
  echo 'colorscheme dracula' >> ${MY_CONFIG_VIM}  
fi

# Install Oh My Zsh
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k
if [[ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  sed -i -e 's/ZSH_THEME="\(.*\)"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ${HOME_ZSHRC}
fi

# Initialize GNU overrides
if ! grep -q "GNU" ${HOME_ZSHRC}; then
  echo "Added GNU shell overrides to ${HOME_ZSHRC}"
  echo '' >> ${HOME_ZSHRC}
  echo '# GNU shell overrides' >> ${HOME_ZSHRC}
  echo 'PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="$(brew --prefix)/opt/gnu-indent/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="$(brew --prefix)/opt/gnu-which/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
fi

# Install brew cask apps
source templates/brew-casks.sh

# Install jEnv
source templates/jenv.sh

# Install Node Version Manager
source templates/nvm.sh

# Append Aliases to .zshrc
if ! grep -q "# Aliases" ${HOME_ZSHRC}; then
  echo "Added Aliases to ${HOME_ZSHRC}."
  echo '' >> ${HOME_ZSHRC}
  cat ./templates/aliases.sh >> ${HOME_ZSHRC}
fi

# Run templates/defaults.sh
source templates/defaults.sh
