#!/usr/bin/env bash
HOME="${HOME:-$(eval echo ~${SUDO_USER:-$USER})}"
HOME_ZSHRC="$HOME/.zshrc"

echo "Installing Zulu OpenJDKs with Homebrew..."

# Uncomment desired versions of JDK casks
# https://formulae.brew.sh/cask/zulu@21

# brew install zulu@8
# brew install zulu@11
# brew install zulu@13
# brew install zulu@15
# brew install zulu@17
# brew install zulu@19
brew install zulu@21

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
