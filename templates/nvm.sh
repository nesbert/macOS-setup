#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"

echo "Installing Node Version Manager (https://nvm.sh)..."
brew install nvm

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
