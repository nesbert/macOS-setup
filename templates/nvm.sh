#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"

echo "Installing Node Version Manager (https://nvm.sh)..."
brew install nvm

# create nvm dir
[ -d "$HOME/.nvm" ] || mkdir "$HOME/.nvm"

# add nvm to .zshrc
if grep -q "# Node Version Manager" ${HOME_ZSHRC}; then
  echo "Skipping nvm already added ${HOME_ZSHRC}."
  exit 0
fi

echo "Added nvm to ${HOME_ZSHRC}."
echo '' >> ${HOME_ZSHRC}

# add/update aliases below comment
cat << 'EOF' >> ${HOME_ZSHRC}
###############################################################################
# Node Version Manager (https://nvm.sh)                                       #
###############################################################################

export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
