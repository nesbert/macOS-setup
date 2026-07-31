#!/usr/bin/env bash
HOME="${HOME:-$(eval echo ~${SUDO_USER:-$USER})}"
HOME_VIM_RUNTIME="${HOME}/.vim_runtime"
HOME_VIM_THEME_ROOT="${HOME}/.vim/pack/themes/start"
HOME_VIM_NORD="${HOME_VIM_THEME_ROOT}/nord-vim"
MY_CONFIG_VIM="${HOME_VIM_RUNTIME}/my_configs.vim"

append_if_missing() {
  local line="$1"

  grep -qxF "$line" "${MY_CONFIG_VIM}" 2>/dev/null || printf '%s\n' "$line" >> "${MY_CONFIG_VIM}"
}

apply_custom_config() {
  append_if_missing "set number"
  append_if_missing "packadd! nord-vim"
  append_if_missing "\" Avoid E28 warnings from Vim's Java syntax Markdown-in-Javadoc support."
  append_if_missing "let g:java_ignore_markdown = 1"
  append_if_missing "syntax enable"
  append_if_missing "colorscheme nord"
  echo "${MY_CONFIG_VIM} updated."
}

case "$1" in
  install)
    echo "ℹ️ Installing Ultimate Vim configuration..."

    if [[ -d "${HOME_VIM_RUNTIME}" ]]; then
      echo "ℹ️ Skipping .vim_runtime already added ${HOME}."
    else
      git clone --depth=1 https://github.com/amix/vimrc.git "${HOME_VIM_RUNTIME}"
      sh "${HOME_VIM_RUNTIME}"/install_awesome_vimrc.sh
    fi

    if [[ -d "${HOME_VIM_NORD}" ]]; then
      echo "ℹ️ Skipping Nord for Vim theme already installed in ${HOME}."
    else
      echo "Installing Nord for Vim theme..."
      [ -d "${HOME_VIM_THEME_ROOT}" ] || mkdir -p "${HOME_VIM_THEME_ROOT}"
      git clone --depth=1 https://github.com/arcticicestudio/nord-vim.git "${HOME_VIM_NORD}"
    fi

    apply_custom_config
    ;;

  update)
    echo "Updating Ultimate Vim configuration..."

    # skip if already installed
    if [[ ! -d "${HOME_VIM_RUNTIME}" ]]; then
      echo "ℹ️ Skipping .vim_runtime not install in ${HOME}."
      exit 0
    fi

    TMP_MY_CONFIG_VIM="$(mktemp /tmp/my_configs.vim.XXXXXX)"
    mv "${MY_CONFIG_VIM}" "${TMP_MY_CONFIG_VIM}"
    rm -rf "${HOME_VIM_RUNTIME}"
    git clone --depth=1 https://github.com/amix/vimrc.git "${HOME_VIM_RUNTIME}"
    sh "${HOME_VIM_RUNTIME}"/install_awesome_vimrc.sh
    mv "${TMP_MY_CONFIG_VIM}" "${MY_CONFIG_VIM}"

    if [[ -d "${HOME_VIM_NORD}" ]]; then
      echo "ℹ️ Updating Nord for Vim theme..."
      rm -rf "${HOME_VIM_NORD}"
    else
      echo "ℹ️ Installing Nord for Vim theme..."
    fi

    [ -d "${HOME_VIM_THEME_ROOT}" ] || mkdir -p "${HOME_VIM_THEME_ROOT}"
    git clone --depth=1 https://github.com/arcticicestudio/nord-vim.git "${HOME_VIM_NORD}"
    apply_custom_config
    ;;

  remove)
    echo "ℹ️ Removing Ultimate Vim configuration..."

    # skip if already installed
    if [[ ! -d "${HOME_VIM_RUNTIME}" ]]; then
      echo "ℹ️ Skipping .vim_runtime not install in ${HOME}."
      exit 0
    fi

    rm -rf "${HOME_VIM_RUNTIME}"
    rm -rf "${HOME}/.vimrc"

    echo "rm -rf ${HOME_VIM_RUNTIME}"
    echo "rm -rf ${HOME}/.vimrc"

    if [[ ! -d "${HOME_VIM_NORD}" ]]; then
      echo "ℹ️ Skipping Nord for Vim theme not install in ${HOME}."
      exit 0
    fi

    rm -rf "${HOME_VIM_NORD}"
    echo "rm -rf ${HOME_VIM_NORD}"

    ;;

  *)
    echo "Usage: $0 {install|update|remove}"
    exit 1
esac
