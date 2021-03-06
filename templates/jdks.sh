#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"

echo "Installing Zulu OpenJDKs (https://github.com/mdogan/homebrew-zulu) ..."

# Uncomment desired versions of JDK
# https://docs.azul.com/core/zulu-openjdk/manage-multiple-zulu-versions/macos
JDKs=(
#  zulu-jdk7
#  zulu-jdk8
#  zulu-jdk11
#  zulu-jdk12
#  zulu-jdk13
#  zulu-jdk14
#  zulu-jdk15
#  zulu-jdk16
  zulu-jdk17
#  zulu-mc
)

brew tap mdogan/zulu
brew install --cask ${JDKs[@]}

echo << EOF
Please add JDKs using jEnv, for example get list of install JDKs...

  /usr/libexec/java_home -V
  jenv add <your_jdk_path>

Other helpful commands...

  jenv version
  jenv versions
  jenv global 16
  jenv local 1.8

Visit https://www.jenv.be for more information.
EOF
