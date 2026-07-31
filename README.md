# macOS-setup

Automation to bootstrap a new Mac for software development with a lightweight,
terminal-first setup.

This repository handles machine setup, package installation, and update
automation. Terminal, prompt, and app configuration live in the companion
repository [macOS-dotfiles](https://github.com/nesbert/macOS-dotfiles).

## Quick start

If this is your first time setting up a Mac with this repo, follow this order:

1. Complete the prerequisites above.
2. Configure SSH and Git signing keys.
3. Clone this repo and the companion dotfiles repo.
4. Optionally customize the Homebrew package list.
5. Run the installer.

### Prerequisites

Before you run the installer, make sure the following are ready:

### Install Command Line Tools (CLT) for Xcode

```sh
xcode-select --install
```

### Optional: Install Rosetta 2 if you need Intel-based binaries such as some Docker builds

```sh
softwareupdate --install-rosetta
```

### Optional: Agree to the Xcode license

```sh
sudo xcodebuild -license accept
```

### Set up SSH and Git signing

Use the official GitHub documentation for full details, then add a minimal SSH config for the default paths:

```txt
# ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

Create a new authentication key:

```sh
ssh-keygen -t ed25519 -C "your-email@example.com"
touch ~/.ssh/config
open ~/.ssh/config

eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

pbcopy < ~/.ssh/id_ed25519.pub
open https://github.com/settings/ssh/new
```

If you also want commit signing, configure your signing key:

```sh
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

### Clone the repositories

```sh
mkdir -p Code/github.com/nesbert
cd Code/github.com/nesbert
git clone git@github.com:nesbert/macOS-setup.git
git clone git@github.com:nesbert/macOS-dotfiles.git
```

### Optional: customize the package list

```sh
cd macOS-setup
cp -Rfv config config.local

# Edit the package lists if you want a different setup
vi config.local/brew-casks.txt
vi config.local/brew-formulae.txt
vi config.local/brew-jdks.txt
```

## Installation

You may be prompted for your password several times during setup.

```sh
# bootstrap the machine, install packages, dotfiles, and DX defaults
./bin/macOS-setup install

# Optional: apply the DX-focused system settings
./bin/macOS-setup system-settings

# Optional: apply personal UI and input preferences
./bin/macOS-setup personal-settings

# Optional follow-up for fzf keybindings and completions
/opt/homebrew/opt/fzf/install
```

If a cask install fails because the app already exists on the machine, rerun
install with an explicit conflict policy:

```sh
# default: stop on the first cask conflict or other cask install failure
BREW_CASK_CONFLICT_POLICY=fail ./bin/macOS-setup install

# overwrite existing app files for casks
BREW_CASK_CONFLICT_POLICY=force ./bin/macOS-setup install

# continue past cask install failures and print a summary at the end
BREW_CASK_CONFLICT_POLICY=skip ./bin/macOS-setup install
```

Running `./bin/macOS-setup install` will:

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
3. Configure their SSH keys and Git identities using [docs/ssh-keys.md](docs/ssh-keys.md) and [docs/multiple-git-accounts.md](docs/multiple-git-accounts.md).
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

## Cask Conflict Policy

The installer now supports `BREW_CASK_CONFLICT_POLICY` for Homebrew casks:

- `fail` is the default. Abort on the first cask install failure.
- `force` reruns cask installs with Homebrew's `--force` flag, which can
  overwrite existing app files.
- `skip` treats cask install failures as non-fatal, continues with the rest of
  the setup, and prints the skipped casks at the end.

Examples:

```sh
BREW_CASK_CONFLICT_POLICY=force ./bin/macOS-setup install
BREW_CASK_CONFLICT_POLICY=skip ./bin/macOS-setup install
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

- [https://medium.com/macoclock/automating-your-macos-setup-with-homebrew-and-cask-e2a103b51af1](https://medium.com/macoclock/automating-your-macos-setup-with-homebrew-and-cask-e2a103b51af1)
- [https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/](https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/)
- [https://github.com/mathiasbynens/dotfiles/blob/main/.macos](https://github.com/mathiasbynens/dotfiles/blob/main/.macos)
