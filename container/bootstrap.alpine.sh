#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
  echo "Use sudo to run this script"
else
  adduser -h /home/developer -s /bin/ash developer

  apk add \
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
        unzip


  service sshd restart
  rc-update add sshd default

  mkdir -p /home/developer
  chown -R developer:developer /home/developer

  rm -rf /home/developer/.profile.d
  git clone https://github.com/antonbashir/local-linux "/home/developer/.profile.d"
  rm -rf "/home/developer/.profile.old"
  cp "/home/developer/.profile" "$HOME/.profile.old"
  cp "/home/developer/.profile.d/container/container.sh" "/home/developer/.profile"

  rm -rf "$HOME/.profile.d"
  git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
  rm -rf "$HOME/.profile.old"
  cp "$HOME/.profile" "$HOME/.profile.old"
  cp "$HOME/.profile.d/container/container.sh" "$HOME/.profile"

  echo "developer ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/username
  chown -R developer:developer /home/developer

  chmod +x /root/.profile
  chmod +x /home/developer/.profile
fi
