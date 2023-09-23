#!/bin/bash

rm -rf "$HOME/.profile.d"
git clone https://github.com/antonbashir/local-linux "$HOME/.profile.d"
cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"

curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
