#!/bin/bash

if [[ $(id -u) == 0 ]] ; then
      apt update
      apt install -y sudo aptitude
else
      sudo apt update
      sudo apt install -y sudo aptitude
fi

sudo aptitude install -y \
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
      python3 \
      nodejs \
      micro \
      clang \
      gcc \
      gpg \
      pass \
      sshfs \
      apt-transport-https \
      asciinema \
      lxc \
      lxcfs \
      lxc-templates

rm -rf "$HOME/.profile.d"
git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
rm -rf "$HOME/.profile.old"
cp "$HOME/.profile" "$HOME/.profile.old"
cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"


if [[ $(grep microsoft /proc/version) ]]; then
  sudo mkdir -p /sys/fs/cgroup/systemd && sudo mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
  sudo mkdir -p /sys/fs/cgroup/systemd && sudo mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
  sudo bash -c "echo 'cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0' >> /etc/fstab"
fi

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

if [[ $(grep microsoft /proc/version) ]]; then
  sudo mkdir -p /sys/fs/cgroup/systemd && sudo mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
fi
