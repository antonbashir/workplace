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
      lxc-templates \
      unzip

wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub
sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main'
sudo tee /etc/apt/sources.list.d/dart_stable.list
sudo apt update
sudo aptitude install dart

go_archive=$(curl https://go.dev/VERSION?m=text | head -1).linux-amd64.tar.gz
wget "https://dl.google.com/go/$go_archive"
tar -xf $go_archive -C $HOME
rm $go_archive

if [[ $(grep microsoft /proc/version) ]]; then
  sudo mkdir -p /sys/fs/cgroup/systemd && sudo mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
  sudo bash -c "echo 'cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0' >> /etc/fstab"
fi

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

rm -rf "$HOME/.profile.d"
git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
rm -rf "$HOME/.profile.old"
cp "$HOME/.profile" "$HOME/.profile.old"
cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"
