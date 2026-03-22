# macOS-setup

Automation to bootstrap a new Mac for software development with a lightweight,
terminal-first setup.

This repository handles machine setup, package installation, and update
automation. Terminal, prompt, and app configuration live in the companion
repository [macOS-dotfiles](https://github.com/nesbert/macOS-dotfiles).

## Prereq

1. Install Command Line Tools (CLT) for Xcode

```sh
xcode-select --install
```

2. Install Rosetta 2 for binaries that are still Darwin/AMD64 (Docker builds, etc)

```sh
softwareupdate --install-rosetta
```

## Installation

```sh
# bootstrap the machine, install packages, and link dotfiles
./bin/install.sh

# optional follow-up for fzf keybindings/completions
/opt/homebrew/opt/fzf/install
```

`bin/install.sh` will:

- install Homebrew if needed
- install CLI packages and cask apps
- install Ghostty, Starship, fastfetch, and related shell tooling
- clone or update `https://github.com/nesbert/macOS-dotfiles`
- back up any existing `~/.zshrc` and `~/.config`
- symlink `~/.zshrc` and `~/.config` from the dotfiles repo

If you want to use a fork or alternate remote for dotfiles, set
`DOTFILES_REPO_URL` before running install:

```sh
DOTFILES_REPO_URL=https://github.com/<you>/macOS-dotfiles.git ./bin/install.sh
```

## Update Software

```sh
# update Homebrew packages/casks and refresh vim config
./bin/update.sh
```

## What does it install?

Below highlights some of the software installed and configured by this script.

- [Homebrew](https://brew.sh) package manager for macOS
- Xcode Command Line Tools updates when available
- [Ghostty](https://ghostty.org) as the primary terminal emulator
- [Starship](https://starship.rs) as the shell prompt
- Homebrew-managed Zsh plugins including autocomplete, autosuggestions, syntax
  highlighting, history substring search, `you-should-use`, and git prompt
- [nvm](https://nvm.sh) with the latest Node.js release set as default
- [jenv](https://www.jenv.be) plus Azul Zulu JDK 21 via Homebrew cask
- [fastfetch](https://github.com/fastfetch-cli/fastfetch) for shell startup system info
- GNU command-line tools such as `coreutils`, `findutils`, `gnu-sed`, and `grep`
- Dotfiles bootstrapped from [macOS-dotfiles](https://github.com/nesbert/macOS-dotfiles)
- Vim enhanced with [The Ultimate vimrc](https://github.com/amix/vimrc) and the [Nord](https://github.com/arcticicestudio/nord-vim) theme
- Other applications & settings for development

`templates/macOS-system-settings.sh` exists for Finder, Dock, keyboard, and
display preferences, but it is currently commented out in
[`bin/install.sh`](bin/install.sh).

### Applications, Tools & Utilities

- Package manager: [Homebrew](https://brew.sh)
- Terminal emulator: [Ghostty](https://ghostty.org)
- Prompt: [Starship](https://starship.rs)
- Shell plugins: [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete), [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting), [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), [zsh-you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use), [zsh-git-prompt](https://github.com/olivierverdier/zsh-git-prompt)
- Node version manager: [nvm](https://nvm.sh)
- Java environment manager: [jenv](https://www.jenv.be)
- JDK: [Azul Zulu JDK 21](https://formulae.brew.sh/cask/zulu@21)
- Vim baseline: [The Ultimate vimrc](https://github.com/amix/vimrc)
- Vim theme: [Nord for Vim](https://github.com/arcticicestudio/nord-vim)
- System info: [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- Editors and developer apps: [Visual Studio Code](https://code.visualstudio.com), [GitHub Desktop](https://desktop.github.com), [Docker Desktop](https://www.docker.com/products/docker-desktop/), [Bruno](https://www.usebruno.com)
- AI tools: [ChatGPT](https://openai.com/chatgpt), [Claude](https://claude.ai/download), [Codex CLI](https://developers.openai.com/codex/cli/), [Codex app](https://openai.com/codex/), [GitHub Copilot CLI](https://github.com/github/copilot-cli), [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- Browsing, chat, and utilities: [Arc](https://arc.net), [Discord](https://discord.com), [AlDente](https://apphousekitchen.com), [AppCleaner](https://freemacsoft.net/appcleaner/), [iMazing](https://imazing.com), [SF Symbols](https://developer.apple.com/sf-symbols/)
- Fonts: [GoMono Nerd Font](https://www.nerdfonts.com/font-downloads), [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads), [Meslo LG Nerd Font](https://www.nerdfonts.com/font-downloads)

## Inspired By

- https://medium.com/macoclock/automating-your-macos-setup-with-homebrew-and-cask-e2a103b51af1
- https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/
- https://github.com/mathiasbynens/dotfiles/blob/main/.macos
