#!/bin/bash

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
cp "$HOME/.profile.d/host/host.sh" "$HOME/.profile"
ln -s "$HOME/.profile" "$HOME/.bashrc"
ln -s "$HOME/.profile" "$HOME/.bash_profile"

curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh