#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"
if grep -q "# Misc" ${HOME_ZSHRC}; then
  echo "Skipping Post to ${HOME_ZSHRC}."
  exit 0
fi

echo "Added Misc to ${HOME_ZSHRC}."
echo '' >> ${HOME_ZSHRC}

# add/update Misc below comment
echo '###############################################################################' >> ${HOME_ZSHRC}
echo '# Misc                                                                        #' >> ${HOME_ZSHRC}
echo '###############################################################################' >> ${HOME_ZSHRC}
echo '' >> ${HOME_ZSHRC}

# pyenv post install support
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ${HOME_ZSHRC}
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ${HOME_ZSHRC}
echo 'eval "$(pyenv init -)"' >> ${HOME_ZSHRC}
