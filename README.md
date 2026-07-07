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

3. Agree to the Xcode license

```sh
sudo xcodebuild -license accept
```

## Installation

```sh
# bootstrap the machine, install packages, dotfiles, and DX defaults
./bin/macOS-setup install

# optional follow-up for fzf keybindings/completions
/opt/homebrew/opt/fzf/install
```

`./bin/macOS-setup install` will:

- install Homebrew if needed
- clone or update the configured dotfiles repo
- install CLI packages and cask apps
- install Ghostty, Starship, fastfetch, and related shell tooling
- back up any existing `~/.zshrc` and `~/.config`
- symlink `~/.zshrc` and `~/.config` from the dotfiles repo

If you want to use a fork, alternate remote, or alternate clone path for
dotfiles, set these before running install:

```sh
DOTFILES_REPO_URL=https://github.com/<you>/macOS-dotfiles.git ./bin/macOS-setup install
DOTFILES_DIR=$HOME/Code/github.com/<you>/macOS-dotfiles ./bin/macOS-setup install
```

## Reusing This Setup

If someone else wants to use these repos on their own Mac, the clean path is:

1. Fork [macOS-dotfiles](https://github.com/nesbert/macOS-dotfiles/).
2. Copy the `*.example` files in [macOS-dotfiles](https://github.com/nesbert/macOS-dotfiles/) to their ignored `*.local`
   counterparts.
3. Configure their SSH keys and Git identities using [SSH Keys](/Users/nesbert/Code/github.com/nesbert/macOS-setup/docs/ssh-keys.md) and [Multiple Git Accounts](/Users/nesbert/Code/github.com/nesbert/macOS-setup/docs/multiple-git-accounts.md).
4. Optionally create `config.local/` files in [macOS-setup](https://github.com/nesbert/macOS-setup/) to trim or expand
   the Homebrew package list without changing the shared defaults.

That keeps the automation reusable while making the machine-specific identity
choices explicit.

## Local Package Selection

This repo ships with default package lists in [`config/`](config), but you can
override them locally with untracked files in `config.local/`.

The installer looks for these files in `config.local/` first:

- `config.local/brew-formulae.txt`
- `config.local/brew-casks.txt`
- `config.local/brew-jdks.txt`

If those files are missing, it falls back to this repo’s defaults in `config/`.

`config.local/` is ignored by Git, so each person can keep a machine-specific
or user-specific package selection without changing the shared open source repo.

The format is intentionally simple: one Homebrew token per line, with blank
lines and `# comments` allowed.

```txt
# config.local/brew-casks.txt
ghostty
visual-studio-code
docker
chatgpt
```

That keeps the shared defaults in version control while giving each user a very
simple override point.

You can also point directly at custom files with environment variables:

```sh
BREW_FORMULAE_FILE=/path/to/brew-formulae.txt \
BREW_CASKS_FILE=/path/to/brew-casks.txt \
BREW_JDKS_FILE=/path/to/brew-jdks.txt \
./bin/macOS-setup install
```

## Update Software

```sh
# update Homebrew packages/casks and refresh vim config
./bin/macOS-setup update
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
- Other applications and settings for development

Optional macOS defaults are split into two scripts:

- `scripts/macOS-system-settings.sh` for broadly useful DX defaults
- `scripts/macOS-personal-settings.sh` for personal UI, hot corner, input, and
  display preferences

The DX-focused settings script is currently run by
[`scripts/macOS-install.sh`](scripts/macOS-install.sh), while the personal settings script stays
opt-in.

```sh
./bin/macOS-setup system-settings
./bin/macOS-setup personal-settings
```

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
