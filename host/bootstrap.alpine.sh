#!/bin/bash

apk add sudo

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
        python3 \
        nodejs \
        micro \
        sshfs \
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

if [[ $(grep microsoft /proc/version) ]]; then
  sudo mkdir -p /sys/fs/cgroup/systemd && sudo mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
fi