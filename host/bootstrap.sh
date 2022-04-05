#!/bin/bash

if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "alpine" ]; then
  sudo apk add wget rsync tar aptitude iproute2 iftop git
  sudo wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
  sudo tar xf nnn-musl-static-4.4.x86_64.tar.gz
  sudo mv nnn-musl-static /usr/bin/files
  sudo rm -rf nnn-musl-static-4.4.x86_64.tar.gz
fi

if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "debian" ]; then
  sudo apt install -y git wget rsync tar aptitude iproute2 iftop
  sudo wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
  sudo tar xf nnn-musl-static-4.4.x86_64.tar.gz
  sudo mv nnn-musl-static /usr/bin/files
  sudo rm -rf nnn-musl-static-4.4.x86_64.tar.gz
fi

rm -rf "$HOME/.bashrc.d"
git clone https://github.com/antonbashir/local-linux "$HOME/.bashrc.d"
cp "$HOME/.bashrc.d/host/host.sh" "$HOME/.bashrc"
