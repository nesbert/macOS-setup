#############################
# Aliases
#############################
 
alias brew-check='brew update && brew outdated'
alias brew-clean-docter='brew cleanup && brew doctor'
alias brew-update='brew-check && brew upgrade && brew-clean-docter'
alias brew-update-casks='brew-check && brew upgrade --cask && brew-clean-docter'
alias brew-update-formula='brew-check && brew upgrade --formula && brew-clean-docter'

alias my-ip="curl http://ipecho.net/plain; echo"
alias my-weather="curl wttr.in/Las+Vegas,+NV+89138"

alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias ll='ls -halFG'

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
