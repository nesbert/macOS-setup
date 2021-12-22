#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"

echo "Installing fzf (https://github.com/junegunn/fzf) ..."
brew install fzf

if grep -q "# fzf" ${HOME_ZSHRC}; then
  echo "Skipping fzf already added to ${HOME_ZSHRC}."
  exit 0
fi

# add fzf to .zshrc
echo "Added fzf to ${HOME_ZSHRC}."
echo '' >> ${HOME_ZSHRC}
cat << 'EOF' >> ${HOME_ZSHRC}
###############################################################################
# fzf (https://github.com/junegunn/fzf)                                       #
###############################################################################

# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
