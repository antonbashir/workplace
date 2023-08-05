#!/bin/bash

if [[ $(id -u) == 0 ]] ; then
      apt update
      apt install -y sudo aptitude
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
      openjdk-11-jdk \
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

sudo wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg
sudo echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list
sudo aptitude update
sudo aptitude -y install dart

sudo wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
sudo tar xf nnn-musl-static-4.4.x86_64.tar.gz
sudo mv nnn-musl-static /usr/bin/files
sudo rm -rf nnn-musl-static-4.4.x86_64.tar.gz

sudo curl -L https://tarantool.io/KKkJBXq/release/2.8/installer.sh | bash
sudo aptitude install -y tarantool

rm -rf "$HOME/.profile.d"
git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"

echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> "$HOME/.profile"
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> "$HOME/.profile"


git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
