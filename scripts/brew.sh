# List of packages
PACKAGES=(
  bat
  claude
  codex
  colordiff
  copilot-cli
  coreutils
  fastfetch
  findutils
  fzf
  gawk
  gh
  git
  grep
  gemini-cli
  gnu-indent
  gnu-sed
  gnu-tar
  gnu-which
  jenv
  jq
  nvm
  pyenv
  starship
  wget
  tree
  vim
  watch
  yamllint
  zsh
  zsh-autocomplete
  zsh-autosuggestions
  zsh-fast-syntax-highlighting
  zsh-git-prompt
  zsh-history-substring-search
  zsh-syntax-highlighting
  zsh-you-should-use
)

echo "Installing `brew` packages..."
brew install ${PACKAGES[@]}
