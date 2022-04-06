#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
  echo "Use sudo to run this script"
else
  aptitude install -y sudo \
        sudo \
        nano \
        htop \
        iftop \
        rsync \
        tree \
        git \
        wget \
        curl \
        ssh \
        iproute2 \
        bsdmainutils \
        neofetch \
        openjdk-11-jdk \
        python3 \
        nodejs \
        micro \
        clang \
        gcc \
        gpg \
        pass

  wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
  tar xf nnn-musl-static-4.4.x86_64.tar.gz
  mv nnn-musl-static /usr/bin/files
  rm -rf nnn-musl-static-4.4.x86_64.tar.gz

  curl -L https://tarantool.io/KKkJBXq/release/2.8/installer.sh | bash
  aptitude install -y tarantool

  rm -rf "$HOME/.profile.d"
  git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
  cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"
fi
