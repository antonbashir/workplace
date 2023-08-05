#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
  echo "Use sudo to run this script"
else
  useradd -m -s /bin/bash developer
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
            openjdk-11-jdk \
            python3 \
            nodejs \
            micro  \
            clang \
            gcc \
            gpg \
            apt-transport-https

  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg
  echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list
  aptitude update
  aptitude -y install dart

  wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
  tar xf nnn-musl-static-4.4.x86_64.tar.gz
  mv nnn-musl-static /usr/bin/files
  rm -rf nnn-musl-static-4.4.x86_64.tar.gz

  curl -L https://tarantool.io/KKkJBXq/release/2.8/installer.sh | bash
  aptitude install -y tarantool

  service ssh restart

  rm -rf /home/developer/.profile.d
  git clone https://github.com/antonbashir/local-linux "/home/developer/.profile.d"
  cp "/home/developer/.profile.d/container/container.sh" "/home/developer/.profile"

  rm -rf "$HOME/.profile.d"
  git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
  cp "$HOME/.profile.d/container/container.sh" "$HOME/.profile"

  echo "developer ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/username
  chown -R developer:developer /home/developer

  chmod +x /root/.profile
  chmod +x /home/developer/.profile

  echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> "$HOME/.profile"
  echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> "/home/developer/.profile"
  echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> "$HOME/.profile"
  echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> "/home/developer/.profile"
fi
