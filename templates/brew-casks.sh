#!/usr/bin/env bash

# List Cask Apps
CASKS=(
  # aldente
  # alfred
  appcleaner
  # blender
  cacher
  discord
  github
  # imazing
  iterm2
  raycast
  # rectangle
  visual-studio-code
  docker
)

echo "Installing cask apps..."
brew install --cask ${CASKS[@]}
