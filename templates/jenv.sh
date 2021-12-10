#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"

echo "Installing jEnv (https://www.jenv.be) ..."
brew install jenv

# Initialize jEnv
if ! grep -q "jEnv" ${HOME_ZSHRC}; then
  # todo separate into zshrc and zprofile
  echo "Added jEnv to ${HOME_ZSHRC}."
  echo '' >> ${HOME_ZSHRC}
  echo '# jEnv support' >> ${HOME_ZSHRC}
  echo 'PATH="$HOME/.jenv/bin:$PATH"' >> ${HOME_ZSHRC}
  PATH="$HOME/.jenv/bin:$PATH"
  echo 'eval "$(jenv init -)"' >> ${HOME_ZSHRC}
  eval "$(jenv init -)"

  jenv enable-plugin maven
  jenv enable-plugin export

  echo "Please add JDKs, example..."
  echo "  /usr/libexec/java_home -V"
  echo "  jenv add <your_jdk_path>"
  echo "Other helpful commands..."
  echo "  jenv version"
  echo "  jenv versions"
  echo "  jenv global 16"
  echo "  jenv local 1.8"
  echo " Visit https://www.jenv.be"
fi

# https://github.com/mdogan/homebrew-zulu
# Multi ENV https://docs.azul.com/core/zulu-openjdk/manage-multiple-zulu-versions/macos
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
echo "Installing Zulu OpenJDKs..."
brew tap mdogan/zulu
brew install --cask ${JDKs[@]}
