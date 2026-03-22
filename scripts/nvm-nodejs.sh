#!/usr/bin/env bash
[ -d "$HOME/.nvm" ] || mkdir "$HOME/.nvm"

export NVM_DIR="$HOME/.nvm"

. "$NVM_DIR/nvm.sh"

nvm install node
nvm alias default node
nvm use default
