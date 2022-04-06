#!/bin/bash

vm() {
        if [ "$1" == "new" ]; then
                if [ "$2" == "debian" ]; then
                        sudo lxc-create -t download -n $3 -- --no-validate -d debian -r bullseye -a amd64
                        return
                fi

                if [ "$2" == "alpine" ]; then
                        sudo lxc-create -t download -n $3 -- --no-validate -d alpine -r edge -a amd64
                        return
                fi
                return
        fi

        if [ "$1" == "forward" ]; then
                sudo iptables -t nat --list-rules | grep '$3' | sed 's/^-A /iptables -t nat -D /g;s/$/;/g' | xargs -I '{}' sudo bash -c '{}'
                sudo iptables -t nat -A PREROUTING -p tcp -i eth0 -m tcp --dport $3 -j DNAT --to-destination "$(sudo lxc-info -n $2 -iH)"
                sudo iptables -t nat -A PREROUTING -p udp -i eth0 -m udp --dport $3 -j DNAT --to-destination "$(sudo lxc-info -n $2 -iH)"
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

        if [ "$1" == "pack" ]; then
                current=$(pwd)
                user=$USER
                sudo bash -c "cd /var/lib/lxc/$2/rootfs && tar --numeric-owner -cpf $current/$3 ./* && chown -R $user:$user $current/$3"
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

        if [ "$1" == "unpack" ]; then
                sudo bash -c "rm -rf /var/lib/lxc/$2/rootfs/*"
                sudo bash -c "tar --numeric-owner -xpf $3 -C /var/lib/lxc/$2/rootfs"
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
