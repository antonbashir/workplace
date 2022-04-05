#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
  echo "Use sudo to run this script"
else
  if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "alpine" ]; then
    apk add wget rsync tar aptitude iproute2 iftop git bsdmainutils
    wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
    tar xf nnn-musl-static-4.4.x86_64.tar.gz
    mv nnn-musl-static /usr/bin/files
    rm -rf nnn-musl-static-4.4.x86_64.tar.gz
  fi

  if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "debian" ]; then
    apt install -y git wget rsync tar aptitude iproute2 iftop util-linux
    wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
    tar xf nnn-musl-static-4.4.x86_64.tar.gz
    mv nnn-musl-static /usr/bin/files
    rm -rf nnn-musl-static-4.4.x86_64.tar.gz
  fi

  rm -rf "$HOME/.profile.d"
  git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
  cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"
fi
