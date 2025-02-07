#!/bin/bash

if [[ $(id -u) == 0 ]] ; then
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
fi

yay -Sy --noconfirm quickemu
yay -Sy --noconfirm nano
yay -Sy --noconfirm htop
yay -Sy --noconfirm iftop
yay -Sy --noconfirm rsync
yay -Sy --noconfirm tree
yay -Sy --noconfirm git
yay -Sy --noconfirm wget
yay -Sy --noconfirm curl
yay -Sy --noconfirm ssh
yay -Sy --noconfirm iproute2
yay -Sy --noconfirm neofetch
yay -Sy --noconfirm python3
yay -Sy --noconfirm nodejs
yay -Sy --noconfirm clang
yay -Sy --noconfirm gcc
yay -Sy --noconfirm gpg
yay -Sy --noconfirm sshfs
yay -Sy --noconfirm lxc
yay -Sy --noconfirm lxcfs
yay -Sy --noconfirm lxc-templates
yay -Sy --noconfirm dart

go_archive=$(curl https://go.dev/VERSION?m=text | head -1).linux-amd64.tar.gz
wget "https://dl.google.com/go/$go_archive"
tar -xf $go_archive -C $HOME
rm $go_archive

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

echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> "$HOME/.profile"
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> "$HOME/.profile"

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh