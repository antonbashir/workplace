#!/bin/bash

vm() {
        if [ "$1" == "new" ]; then
                if [ "$2" == "debian" ]; then
                        sudo lxc-create -t download -n $3 -- -d debian -r bookworm -a amd64
			                  sudo sed -i 's/lxcbr0/lxc-network/g' /var/lib/lxc/$3/config
                        return
                fi

                if [ "$2" == "alpine" ]; then
                        sudo lxc-create -t download -n $3 -- -d alpine -r edge -a amd64
			                  sudo sed -i 's/lxcbr0/lxc-network/g' /var/lib/lxc/$3/config
                        return
                fi
                return
        fi

        if [ "$1" == "forward" ]; then
                sudo iptables -t nat --list-rules | grep $3 | sed 's/^-A /iptables -t nat -D /g;s/$/;/g' | xargs -I '{}' sudo bash -c '{}'
                sudo iptables -t nat -A PREROUTING -p tcp -i eth0 -m tcp --dport $3 -j DNAT --to-destination "$(sudo lxc-info -n $2 -iH)"
                sudo iptables -t nat -A PREROUTING -p udp -i eth0 -m udp --dport $3 -j DNAT --to-destination "$(sudo lxc-info -n $2 -iH)"
                return
        fi

        if [ "$1" == "deny" ]; then
                sudo iptables -t nat --list-rules | grep $2 | sed 's/^-A /iptables -t nat -D /g;s/$/;/g' | xargs -I '{}' sudo bash -c '{}'
                return
        fi

        if [ "$1" == "shell" ]; then
                sudo lxc-attach -n $2
                return
        fi

        if [ "$1" == "login" ]; then
                ssh "$3@$(sudo lxc-info -n $2 -iH)"
                return
        fi

        if [ "$1" == "start" ]; then
                sudo lxc-start -n $2
                return
        fi

        if [ "$1" == "stop" ]; then
                sudo lxc-stop -n $2 -k
                return
        fi

        if [ "$1" == "rm" ]; then
                sudo lxc-destroy -n $2
                return
        fi

        if [ "$1" == "backup" ]; then
                current=$(pwd)
                user=$USER
                sudo bash -c "cd /var/lib/lxc/$2/rootfs && tar --numeric-owner --one-file-system -cpf $current/$3 ./* && chown -R $user:$user $current/$3"
                return
        fi

        if [ "$1" == "restore" ]; then
                sudo bash -c "rm -rf /var/lib/lxc/$2/rootfs/*"
                sudo bash -c "tar --numeric-owner -xpf $3 -C /var/lib/lxc/$2/rootfs"
                return
        fi

        if [ "$1" == "export" ]; then
                current=$(pwd)
                user=$USER
                sudo bash -c "cd /var/lib/lxc/$2/rootfs && tar --numeric-owner --one-file-system -cpf $current/$2.tar.gz ./* && chown -R $user:$user $current/$2.tar.gz"
                return
        fi

        if [ "$1" == "import" ]; then
                current=$(pwd)
                user=$USER
                if [ "$2" == "debian" ]; then
                    sudo lxc-create -t download -n $3 -- --no-validate -d debian -r bullseye -a amd64
                fi

                if [ "$2" == "alpine" ]; then
                        sudo lxc-create -t download -n $3 -- --no-validate -d alpine -r edge -a amd64
                fi
                sudo bash -c "rm -rf /var/lib/lxc/$3/rootfs/*"
                sudo bash -c "tar --numeric-owner -xpf $4 -C /var/lib/lxc/$3/rootfs"
                return
        fi

        if [ "$1" == "put" ]; then
                sudo cp -r $3 /var/lib/lxc/$2/rootfs/$4
                sudo lxc-attach -n $2 -- chown -R developer:developer $4
                return
        fi

        if [ "$1" == "get" ]; then
                sudo cp -r /var/lib/lxc/$2/rootfs/$3 $4
                return
        fi

        if [ "$1" == "ip" ]; then
                sudo lxc-info -n $2 -iH
                return
        fi

        if [ "$1" == "mount" ]; then
                sshfs "developer@$(sudo lxc-info -n $2 -iH):$3" $4
                return
        fi

        if [ "$1" == "help" ]; then
                echo "vm command helps you to manage LXC containers"
                echo "[vm new debian test] - create Debian LXC container named test"
                echo "[vm new alpine test] - create Alpine LXC container named test"
                echo "[vm forward test 8080:8090] - forwards 8080-8090 ports from your current host to the container"
                echo "[vm deny 8080:8090] - disable the forwarding"
                echo "[vm shell test] - attache to LXC the container"
                echo "[vm login test developer] - SSH login to LXC the container"
                echo "[vm start test] - start the LXC container"
                echo "[vm stop test] - stop the LXC container"
                echo "[vm rm test] - destroy the LXC container"
                echo "[vm backup test test.tar.gz] - export rootfs of the LXC container to the archive"
                echo "[vm restore test test.tar.gz] - import rootfs of the LXC container from the archive"
                echo "[vm export test] - export rootfs of the LXC container to the archive named test.tar.gz in your current directory"
                echo "[vm import debian test test.tar.gz] - create Debian LXC container named test from the archive"
                echo "[vm import alpine test test.tar.gz] - create Alpine LXC container named test from the archive"
                echo "[vm put test test.file] - copy the file to the LXC container"
                echo "[vm get test remote.file local.file] - copy remote.file from test container to local.file"
                echo "[vm ip test] - show IP address of the LXC container"
                echo "[vm mount test /home/developer/remote local] - mount the remote path of the LXC container to the local point"
                echo "[vm configure] - configure host settings for LXC"
                return
        fi

        if [ "$1" == "configure" ]; then
        sudo apt install -y lxc lxcfs lxc-templates

        cat <<EOF > configure-dns
dhcp-host=connect.local,192.168.128.2
EOF

        cat <<EOF > configure-lxc-config
lxc.net.0.type = veth
lxc.net.0.link = lxc-network
lxc.net.0.flags = up
lxc.apparmor.profile = generated
lxc.apparmor.allow_nesting = 1
EOF

        cat  <<EOF > configure-lxc-default
LXC_AUTO="true"
BOOTGROUPS="onboot,"
SHUTDOWNDELAY=5
OPTIONS=
STOPOPTS="-a -A -s"
USE_LXC_BRIDGE="true"
LXC_BRIDGE="lxc-network"
LXC_ADDR="192.168.128.1"
LXC_NETMASK="255.255.255.0"
LXC_NETWORK="192.168.128.0/24"
LXC_DHCP_RANGE="192.168.128.2,192.168.128.254"
LXC_DHCP_MAX="253"
LXC_DHCP_CONFILE="/etc/lxc/dnsmasq.conf"
LXC_DOMAIN=""
EOF
        sudo cp configure-dns /etc/lxc/dnsmasq.conf
        sudo cp configure-lxc-config /etc/lxc/default.conf
        sudo cp configure-lxc-default /etc/default/lxc

        sudo rm configure-dns
        sudo rm configure-lxc-config
        sudo rm configure-lxc-default

        sudo service lxc-net restart
        return
        fi

        sudo lxc-ls -f
}
