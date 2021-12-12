# macOS-setup

Automation to setup new MacBook for software development.

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
# first run install
./install.sh

# update
./update.sh
```

## What does it install?

Below highlights some of the software installed and configured by this script.

* [Homebrew](https://brew.sh) package manager for macOS
* [Oh My Zsh](https://github.com/romkatv/powerlevel10k) with the Powerlevel10k theme
* zshrc enhancements with [aliases](templates/aliases.sh) etc.
* Enhances the Vim xp with "[The Ultimate vimrc](https://github.com/amix/vimrc)" and [Dracula](https://github.com/dracula/vim) theme
* Updates system wide macOS [default preferences](templates/defaults.sh) see [dotfiles/.macos](https://github.com/mathiasbynens/dotfiles/blob/main/.macos)
* Other applications & settings for development

### Applications, Tools & Utilities

* Package Manager https://brew.sh
* Pimp out ZSH! https://ohmyz.sh, https://github.com/romkatv/powerlevel10k
* Node Version Manager https://nvm.sh
* Java Environment Manager https://www.jenv.be
* Zulu JDK Homebrew Casks https://github.com/mdogan/homebrew-zulu
* The Ultimate vimrc https://github.com/amix/vimrc
* macOS Terminal Emulator https://iterm2.com
* Code Editing. Refined. https://code.visualstudio.com
* Docker for macOS https://docs.docker.com/desktop/mac/install/
* Launcher & Productivity Booster https://www.alfredapp.com vs https://www.raycast.com
* Window Management https://magnet.crowdcafe.com vs https://rectangleapp.com
* Talk, Chat & Hangout https://discord.com
* Github https://cli.github.com, https://desktop.github.com, https://www.cacher.io (Gist Manager)
* Battery Limiter https://apphousekitchen.com
* 3d Creation Softare https://www.blender.org
* iDevice Manager https://imazing.com

## Inspired By

* https://medium.com/macoclock/automating-your-macos-setup-with-homebrew-and-cask-e2a103b51af1
* https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/
* https://github.com/mathiasbynens/dotfiles/blob/main/.macos