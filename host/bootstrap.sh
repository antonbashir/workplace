#!/bin/bash

if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "alpine" ]; then
  sudo apk add git
fi

if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "debian" ]; then
  sudo apt install git
fi

git clone https://github.com/antonbashir/local-linux "$HOME/.bashrc.d"
cp "$HOME/.bashrc.d/host/host.sh" "$HOME/.bashrc"
