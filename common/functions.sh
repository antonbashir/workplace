#!/bin/bash

dir() {
        mkdir -p $1
}

own() {
        sudo chown -R $1:$1 $2
}

toExecutable() {
        sudo chmod +x $1
}

toFile() {
        sudo chmod 0644 $1
}

toDir() {
        sudo chmod 755 $1
}


prepare() {
    if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "alpine" ]; then
      alias package='sudo apk add wget rsync tar aptitude iproute2 iftop'
    fi

    if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "debian" ]; then
      sudo apt install -y wget rsync tar aptitude iproute2 iftop
    fi

    sudo wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-musl-static-4.4.x86_64.tar.gz
    sudo tar xf nnn-musl-static-4.4.x86_64.tar.gz
    sudo mv nnn-musl-static /usr/bin/files
    sudo rm -rf nnn-musl-static-4.4.x86_64.tar.gz
}
