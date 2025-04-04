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

reload() {
  cd "$HOME/.profile.d" && git pull
}

status() {
  python $HOME/.profile.d/common/status.py $1
}
