#!/bin/bash

if [[ $(id -u) == 0 ]] ; then
  apk add sudo aptitude
fi

sudo apk add \
        sudo \
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
        lxc \
        lxcfs

rm -rf "$HOME/.profile.d"
git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
