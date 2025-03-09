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
        ncdu \
        unzip

  service sshd restart
  rc-update add sshd default

  mkdir -p /home/developer
  chown -R developer:developer /home/developer

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
  cp "$HOME/.profile.d/container/container.sh" "$HOME/.profile"
  ln -s "$HOME/.profile" "$HOME/.bashrc"
  ln -s "$HOME/.profile" "$HOME/.bash_profile"

  rm -rf "/home/developer/.profile.d"
  git clone https://github.com/antonbashir/workplace "/home/developer/.profile.d"
  rm -rf "/home/developer/.profile.old"
  rm -rf "/home/developer/.bashrc.old"
  rm -rf "/home/developer/.bash_profile.old"
  [[ -e "/home/developer/.profile" ]] && cp "/home/developer/.profile" "/home/developer/.profile.old"
  [[ -e "/home/developer/.bashrc" ]] && cp "/home/developer/.bashrc" "/home/developer/.bashrc.old"
  [[ -e "/home/developer/.bash_profile" ]] && cp "/home/developer/.bash_profile" "/home/developer/.bash_profile.old"
  rm -rf "/home/developer/.profile"
  rm -rf "/home/developer/.bashrc"
  rm -rf "/home/developer/.bash_profile"
  cp "/home/developer/.profile.d/container/container.sh" "/home/developer/.profile"
  ln -s "/home/developer/.profile" "/home/developer/.bashrc"
  ln -s "/home/developer/.profile" "/home/developer/.bash_profile"

  echo "developer ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/username
  chown -R developer:developer /home/developer

  chmod +x $HOME/.profile
  chmod +x /home/developer/.profile
fi
