#!/bin/bash

if [[ $(id -u) == 0 ]] ; then
      apt update
      apt install -y sudo aptitude
else
      sudo apt update
      sudo apt install -y sudo aptitude
fi

sudo aptitude install -y \
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
      python3 \
      nodejs \
      clang \
      gcc \
      gpg \
      pass \
      sshfs \
      apt-transport-https \
      asciinema \
      lxc \
      lxcfs \
      lxc-templates \
      bash \
      genisoimage \
      coreutils \
      grep \
      jq  \
      mesa-utils  \
      ovmf  \
      pciutils  \
      procps  \
      qemu-system  \
      sed  \
      socat  \
      spice-client-gtk  \
      swtpm-tools  \
      unzip  \
      usbutils  \
      util-linux  \
      uuidgen-runtime  \
      xdg-user-dirs  \
      xrandr  \
      zsync \
      unzip

sudo wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg
sudo echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list
sudo aptitude update
sudo aptitude -y install dart

go_archive=$(curl https://go.dev/VERSION?m=text | head -1).linux-amd64.tar.gz
wget "https://dl.google.com/go/$go_archive"
sudo mkdir -p /usr/local
sudo tar -xf $go_archive -C /usr/local
rm $go_archive

if [[ $(grep microsoft /proc/version) ]]; then
  sudo mkdir -p /sys/fs/cgroup/systemd && sudo mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
  sudo bash -c "echo 'cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0' >> /etc/fstab"
fi

sudo wget -qO- https://github.com/quickemu-project/quickemu/releases/download/4.9.7/quickemu_4.9.7-1_all.deb
sudo aptitude install -y ./quickemu_4.9.7-1_all.deb
sudo rm -rf ./quickemu_4.9.7-1_all.deb

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