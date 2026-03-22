#!/usr/bin/env bash

# List Cask Apps
CASKS=(
  aldente
  appcleaner
  # alfred
  arc
  # blender
  bruno
  chatgpt
  claude
  codex
  codex-app
  copilot-cli
  discord
  docker
  font-go-mono-nerd-font
  font-jetbrains-mono-nerd-font
  font-meslo-lg-nerd-font
  ghostty
  github
  sf-symbols
  visual-studio-code
)

echo "Installing `brew cask` apps..."
brew install --cask ${CASKS[@]}
