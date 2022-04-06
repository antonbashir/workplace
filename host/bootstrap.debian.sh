#!/bin/bash

sudo aptitude install -y
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

sudo wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
sudo tar xf nnn-musl-static-4.4.x86_64.tar.gz
sudo mv nnn-musl-static /usr/bin/files
sudo rm -rf nnn-musl-static-4.4.x86_64.tar.gz

sudo curl -L https://tarantool.io/KKkJBXq/release/2.8/installer.sh | bash
sudo aptitude install -y tarantool

rm -rf "$HOME/.profile.d"
git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"

