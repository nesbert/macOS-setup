#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"

echo "Installing Zulu OpenJDKs with Homebrew..."

# Uncomment desired versions of JDK casks
# https://formulae.brew.sh/cask/zulu@21
JDKs=(
#  zulu@8
#  zulu@11
#  zulu@13
#  zulu@15
#  zulu@17
#  zulu@19
  zulu@21
)

brew install ${JDKs[@]}

echo << EOF
Please add JDKs using jEnv, for example get list of install JDKs...

  /usr/libexec/java_home -V
  jenv add <your_jdk_path>

Other helpful commands...

  jenv version
  jenv versions
  jenv global 21
  jenv local 1.8

Visit https://www.jenv.be for more information.
EOF
