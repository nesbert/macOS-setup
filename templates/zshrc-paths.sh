#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"

if grep -q "# GNU" ${HOME_ZSHRC}; then
  echo "Skipping GNU Shell Overrides to ${HOME_ZSHRC}."
  exit 0
fi

echo "Added GNU Shell Ooverrides to ${HOME_ZSHRC}"
echo '' >> ${HOME_ZSHRC}

# add/update GNU overrides
cat << 'EOF' >> ${HOME_ZSHRC}
###############################################################################
# GNU Shell Overrides                                                         #
###############################################################################

export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/gawk/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/gnu-indent/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/gnu-which/libexec/gnubin:$PATH"
