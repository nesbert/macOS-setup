#!/usr/bin/env bash
HOME="${HOME:-$(eval echo ~${SUDO_USER:-$USER})}"
[ -d "$HOME/.nvm" ] || mkdir "$HOME/.nvm"

export NVM_DIR="$HOME/.nvm"

. "$NVM_DIR/nvm.sh"

nvm install node
nvm alias default node
nvm use default
