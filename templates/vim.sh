#!/usr/bin/env bash
HOME_VIM_RUNTIME="${HOME}/.vim_runtime"
HOME_VIM_DRACULA="${HOME}/.vim/pack/themes/start/dracula"

case "$1" in
  install)
    echo "Installing Ultimate Vim configuration..."

    # skip if already installed
    if [[ -d "${HOME_VIM_RUNTIME}" ]]; then
      echo "Skipping .vim_runtime already added ${HOME}."
      exit 0
    fi

    git clone --depth=1 https://github.com/amix/vimrc.git "${HOME_VIM_RUNTIME}"
    sh "${HOME_VIM_RUNTIME}"/install_awesome_vimrc.sh

    # check for .vim dracula theme
    if [[ -d "${HOME_VIM_DRACULA}" ]]; then
      echo "Skipping Dracula for Vim theme already installed in ${HOME}."
      exit 0
    fi

    # create directory if it does not exist
    [ -d "${HOME}/.vim/pack/themes/start" ] || mkdir -p "${HOME}/.vim/pack/themes/start"
    git clone --depth=1 https://github.com/dracula/vim.git "${HOME_VIM_DRACULA}"

    # todo should probably check if already set
    MY_CONFIG_VIM="${HOME_VIM_RUNTIME}"/my_configs.vim
    echo "set number" >> ${MY_CONFIG_VIM}
    echo 'packadd! dracula' >> ${MY_CONFIG_VIM}
    echo 'syntax enable' >> ${MY_CONFIG_VIM}
    echo 'colorscheme dracula' >> ${MY_CONFIG_VIM}
    ;;

  update)
    echo "Updating Ultimate Vim configuration..."

    # skip if already installed
    if [[ ! -d "${HOME_VIM_RUNTIME}" ]]; then
      echo "Skipping .vim_runtime not install in ${HOME}."
      exit 0
    fi

    mv "${HOME_VIM_RUNTIME}"/my_configs.vim /tmp
    rm -rf "${HOME_VIM_RUNTIME}"
    git clone --depth=1 https://github.com/amix/vimrc.git "${HOME_VIM_RUNTIME}"
    sh "${HOME_VIM_RUNTIME}"/install_awesome_vimrc.sh
    mv /tmp/my_configs.vim "${HOME_VIM_RUNTIME}"

    if [[ ! -d "${HOME_VIM_DRACULA}" ]]; then
      echo "Skipping Dracula for Vim theme not install in ${HOME}."
      exit 0
    fi

    echo "Updating Dracula for Vim theme..."
    rm -rf "${HOME_VIM_DRACULA}"
    [ -d "${HOME}/.vim/pack/themes/start" ] || mkdir -p "${HOME}/.vim/pack/themes/start"
    git clone --depth=1 https://github.com/dracula/vim.git "${HOME_VIM_DRACULA}"
    ;;

  remove)
    echo "Removing Ultimate Vim configuration..."

    # skip if already installed
    if [[ ! -d "${HOME_VIM_RUNTIME}" ]]; then
      echo "Skipping .vim_runtime not install in ${HOME}."
      exit 0
    fi

    rm -rf "${HOME_VIM_RUNTIME}"
    rm -rf "${HOME}/.vimrc"

    echo "rm -rf ${HOME_VIM_RUNTIME}"
    echo "rm -rf ${HOME}/.vimrc"

    if [[ ! -d "${HOME_VIM_DRACULA}" ]]; then
      echo "Skipping Dracula for Vim theme not install in ${HOME}."
      exit 0
    fi

    rm -rf "${HOME_VIM_DRACULA}"
    echo "rm -rf ${HOME_VIM_DRACULA}"

    ;;

  *)
    echo "Usage: $0 {install|update|remove}"
    exit 1
esac