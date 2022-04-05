#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
  echo "Use sudo to run this script"
else
  adduser -h /home/developer -s /bin/ash developer
  passwd developer

  apk add nano htop iftop rsync tree git wget curl openssh iproute2 util-linux
  wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
  tar xf nnn-musl-static-4.4.x86_64.tar.gz
  mv nnn-musl-static /usr/bin/files
  rm -rf nnn-musl-static-4.4.x86_64.tar.gz

  service sshd restart

  rm -rf /home/developer/.bashrc.d
  git clone https://github.com/antonbashir/local-linux "/home/developer/.bashrc.d"
  cp "/home/developer/.bashrc.d/container/container.sh" "/home/developer/.bashrc"

  rm -rf "$HOME/.bashrc.d"
  git clone https://github.com/antonbashir/local-linux "$HOME/.bashrc.d"
  cp "$HOME/.bashrc.d/container/container.sh" "$HOME/.bashrc"

  echo "developer ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/username
  chown -R developer:developer /home/developer

  chmod +x /root/.bashrc
  chmod +x /home/developer/.bashrc
fi
