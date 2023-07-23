#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"

if grep -q "# Aliases" ${HOME_ZSHRC}; then
  echo "Skipping Aliases to ${HOME_ZSHRC}."
  exit 0
fi

echo "Added Aliases to ${HOME_ZSHRC}."
echo '' >> ${HOME_ZSHRC}

# add/update aliases below comment
cat << 'EOF' >> ${HOME_ZSHRC}
###############################################################################
# Aliases                                                                     #
###############################################################################

alias brew-check='brew update && brew outdated'
alias brew-clean-doctor='brew cleanup && brew doctor'
alias brew-update='brew-check && brew upgrade && brew-clean-doctor'
alias brew-update-casks='brew-check && brew upgrade --cask && brew-clean-doctor'
alias brew-update-formula='brew-check && brew upgrade --formula && brew-clean-doctor'

alias nvm-update-lts='nvm install "lts/*" --reinstall-packages-from="$(nvm current)"'

alias my-ip="curl ifconfig.io"
alias my-weather="curl wttr.in/Las+Vegas,+NV+89138"

alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias ll='gls --l --color -halFG'

alias df='df -lh'
alias du='du -h'
alias space='df'

alias edit='code '
alias now='echo `date`'
alias x='clear'
alias h='history'
alias ping='ping -c 3'
alias bye='logout'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

alias restart-macos="sudo shutdown -r now"
alias clean-python="rm -rf .pytest_cache dist htmlcov venv; \
                    find . -type f -name '.coverage' -delete; \
                    find . -type d -name '__pycache__' -exec rm -rf {} +; \
                    find . -type d -name '*.egg-info' -exec rm -rf {} +"
