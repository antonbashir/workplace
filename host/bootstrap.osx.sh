#!/bin/bash

rm -rf "$HOME/.profile.d"
git clone https://github.com/antonbashir/workplace "$HOME/.profile.d"
cp "$HOME/.profile.d/host/host.sh" "$HOME/.bash_profile"
