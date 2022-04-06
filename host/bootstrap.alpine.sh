#!/bin/bash

sudo apk add \
    nano \
    htop \
    iftop \
    rsync \
    tree \
    git \
    wget \
    curl \
    openssh \
    iproute2 \
    util-linux \
    neofetch \
    openjdk11 \
    python3 \
    nodejs \
    micro \
    clang \
    gcc \
    gpg \
    pass \
    sshfs

SUDO wget https://github.com/antonbashir/local-linux-packages/raw/9ab9daa4b3fa4887fb05ec7d3542814bb0317101/alpine/tarantool/2.8.3/tarantool-2.8.3-r0.apk
sudo apk add --allow-untrusted tarantool-2.8.3-r0.apk
sudo rm -rf tarantool-2.8.3-r0.apk

sudo wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
sudo tar xf nnn-musl-static-4.4.x86_64.tar.gz
sudo mv nnn-musl-static /usr/bin/files
sudo rm -rf nnn-musl-static-4.4.x86_64.tar.gz

rm -rf "$HOME/.profile.d"
git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"
