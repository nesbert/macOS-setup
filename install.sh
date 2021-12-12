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
  colordiff
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

# Install The Ultimate vimrc
./templates/vim.sh install

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

# Add PATHs to .zshrc
./templates/paths.sh

# Install brew cask apps
./templates/brew-casks.sh

# Install jEnv
./templates/jenv.sh

# Install Node Version Manager
./templates/nvm.sh

# Append Aliases to .zshrc
./templates/aliases.sh

# Run templates/defaults.sh
./templates/defaults.sh

# Reload zsh
source ~/.zshrc