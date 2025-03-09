#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
  echo "Use sudo to run this script"
else
  /sbin/useradd -m -s /bin/bash developer
  sudo mkdir -p /home/developer
  sudo chown -R developer:developer /home/developer/
  passwd developer

  apt update
  apt install -y aptitude
  aptitude install -y sudo \
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
            micro  \
            clang \
            gcc \
            gpg \
            apt-transport-https \
            ncdu \
            unzip

  service ssh restart
  
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg
  echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
  sudo apt update && sudo aptitude install dart

  go_archive=$(curl https://go.dev/VERSION?m=text | head -1).linux-amd64.tar.gz
  wget "https://dl.google.com/go/$go_archive"
  tar -xf $go_archive -C /home/developer
  tar -xf $go_archive -C $HOME
  rm $go_archive

  echo "developer ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/username

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

  chown -R developer:developer /home/developer

  chmod +x $HOME/.profile
  chmod +x /home/developer/.profile
fi
