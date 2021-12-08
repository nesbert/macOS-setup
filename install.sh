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
  jenv
  jq
  nvm
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
  echo "set number" >> ${HOME}/.vim_runtime/my_configs.vim
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

# Initialize jEnv
if ! grep -q "jEnv" ${HOME_ZSHRC}; then
  # todo separate into zshrc and zprofile
  echo "Added jEnv to ${HOME_ZSHRC}."
  echo '' >> ${HOME_ZSHRC}
  echo '# jEnv support' >> ${HOME_ZSHRC}
  echo 'PATH="$HOME/.jenv/bin:$PATH"' >> ${HOME_ZSHRC}
  PATH="$HOME/.jenv/bin:$PATH"
  echo 'eval "$(jenv init -)"' >> ${HOME_ZSHRC}
  eval "$(jenv init -)"

  jenv enable-plugin maven
  jenv enable-plugin export

  echo "Please add JDKs, example..."
  echo "  /usr/libexec/java_home -V"
  echo "  jenv add <your_jdk_path>"
  echo "Other helpful commands..."
  echo "  jenv version"
  echo "  jenv versions"
  echo "  jenv global 16"
  echo "  jenv local 1.8"
  echo " Visit https://www.jenv.be"
fi

# https://github.com/mdogan/homebrew-zulu
# Multi ENV https://docs.azul.com/core/zulu-openjdk/manage-multiple-zulu-versions/macos
JDKs=(
#  zulu-jdk7
  zulu-jdk8
#  zulu-jdk11
#  zulu-jdk12
#  zulu-jdk13
#  zulu-jdk14
#  zulu-jdk15
#  zulu-jdk16
  zulu-jdk17
#  zulu-mc
)
echo "Installing Zulu OpenJDKs..."
brew tap mdogan/zulu
brew install --cask ${JDKs[@]}

# Initialize Node Version Manager
if ! grep -q "nvm" ${HOME_ZSHRC}; then
  # create nvm dir
  [ -d "$HOME/.nvm" ] || mkdir "$HOME/.nvm"
  echo "Added nvm to ${HOME_ZSHRC}."
  echo '' >> ${HOME_ZSHRC}
  echo '# nvm support' >> ${HOME_ZSHRC}
  # Set nvm workspace
  echo 'NVM_DIR="$HOME/.nvm"' >> ${HOME_ZSHRC}
  # Load nvm
  echo '[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"' >> ${HOME_ZSHRC}
  # Load nvm bash_completion
  echo '[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"' >> ${HOME_ZSHRC}
fi

# List Cask Apps
CASKS=(
  # aldente
  # alfred
  appcleaner
  # blender
  cacher
  discord
  github
  # imazing
  iterm2
  raycast
  # rectangle
  visual-studio-code
  docker
)

echo "Installing cask apps..."
brew install --cask ${CASKS[@]}

# Initialize Node Version Manager
if ! grep -q "# Aliases" ${HOME_ZSHRC}; then
  echo "Added Aliases to ${HOME_ZSHRC}."
  echo '' >> ${HOME_ZSHRC}
  cat ./templates/aliases.sh >> ${HOME_ZSHRC}
fi

echo "Running macOS defaults.sh..."
# Run templates/defaults.sh
source templates/defaults.sh
