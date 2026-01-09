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
        fastfetch \
        python3 \
        nodejs \
        micro \
        sshfs \
        clang \
        gcc \
        lxc \
        lxcfs \
        ncdu \
        lsd \
        unzip

if [[ $(grep microsoft /proc/version) ]]; then
  sudo mkdir -p /sys/fs/cgroup/systemd && sudo mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
  sudo bash -c "echo 'cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0' >> /etc/fstab"
fi

rm -rf "$HOME/.profile.d"
git clone https://github.com/antonbashir/workplace "$HOME/.profile.d"
rm -rf "$HOME/.profile.old"
rm -rf "$HOME/.bashrc.old"
rm -rf "$HOME/.bash_profile.old"
[[ -e "$HOME/.profile" ]] && cp "$HOME/.profile" "$HOME/.profile.old"
[[ -e "$HOME/.bashrc" ]] && cp "$HOME/.bashrc" "$HOME/.bashrc.old"
[[ -e "$HOME/.bash_profile" ]] && cp "$HOME/.bash_profile" "$HOME/.bash_profile.old"
rm -rf "$HOME/.profile"
rm -rf "$HOME/.bashrc"
rm -rf "$HOME/.bash_profile"
cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"
ln -s "$HOME/.profile" "$HOME/.bashrc"
ln -s "$HOME/.profile" "$HOME/.bash_profile"

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
