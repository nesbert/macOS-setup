#!/usr/bin/env bash
HOME_ZSHRC="$HOME/.zshrc"

echo "Installing jEnv (https://www.jenv.be) ..."
brew install jenv

# uncomment desired versions of JDK
# https://github.com/mdogan/homebrew-zulu
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

echo "Installing Zulu OpenJDKs..."
brew tap mdogan/zulu
brew install --cask ${JDKs[@]}

echo << EOF
Please add JDKs, for example get list of install JDKs...

  /usr/libexec/java_home -V
  jenv add <your_jdk_path>

Other helpful commands...

  jenv version
  jenv versions
  jenv global 16
  jenv local 1.8

Visit https://www.jenv.be for more information.
EOF

if grep -q "# jEnv" ${HOME_ZSHRC}; then
  echo "Skipping jEnv already added to ${HOME_ZSHRC}."
  exit 0
fi

# add jEnv to .zshrc
echo "Added jEnv to ${HOME_ZSHRC}."
echo '' >> ${HOME_ZSHRC}
cat << 'EOF' >> ${HOME_ZSHRC}
###############################################################################
# jEnv (https://www.jenv.be)                                                  #
###############################################################################

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
