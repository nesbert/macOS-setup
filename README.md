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

## Inspired By

* https://medium.com/macoclock/automating-your-macos-setup-with-homebrew-and-cask-e2a103b51af1
* https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/