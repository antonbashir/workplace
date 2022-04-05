#!/bin/bash

useradd -m -s /bin/bash developer
passwd developer

apt update
apt install -y aptitude
aptitude install -y sudo nano htop iftop rsync tree git wget curl ssh

service ssh restart

git clone https://github.com/antonbashir/local-linux "$HOME/.bashrc.d"
cp "$HOME/.bashrc.d/container/container.sh" "$HOME/.bashrc"

echo "developer ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/username
chown -R developer:developer /home/developer

chmod +x /root/.bashrc
chmod +x /home/developer/.bashrc
