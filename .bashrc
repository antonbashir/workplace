[ -z "$PS1" ] && return
shopt -s checkwinsize
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
        function command_not_found_handle {
                if [ -x /usr/lib/command-not-found ]; then
                                        /usr/lib/command-not-found -- "$1"
                   return $?

                elif [ -x /usr/share/command-not-found/command-not-found ]; then
                                        /usr/share/command-not-found/command-not-found -- "$1"
                   return $?

                else
                   printf "%s: command not found\n" "$1" >&2
                   return 127
                fi
        }
fi


alias ll='ls -alt --color=always --time-style=long-iso'
alias rm='rm -rf'
alias apt='sudo aptitude'
alias transfer='rsync -ah --info=progress2'
alias pack='tar cf'
alias unpack='tar xf'
alias mount='mount | column -t'
alias path='echo -e ${PATH//:/\\n}'
alias tree='tree -Ca'
alias root='sudo -i'
alias download="wget -N"

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
                sudo iptables --table nat --append PREROUTING -p tcp -i eth0 -m tcp --dport $2 -j DNAT --to-destination $(sudo lxc-info -n $3 -iH)
                sudo iptables --table nat --append PREROUTING -p udp -i eth0 -m udp --dport $2 -j DNAT --to-destination $(sudo lxc-info -n $3 -iH)
                return
        fi

        if [ "$1" == "shell" ]; then
                sudo lxc-attach -n $2
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

        if [ "$1" == "configure" ]; then
        sudo apt install lxc lxcfs lxc-templates

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

dir() {
        if [ ! -d "$1" ]; then
                mkdir -p $1
        fi
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


function prompt() {
        local time_color="\[\e[0;38;5;27m\]"
        local user_host_color="\[\e[0;38;5;39m\]"
        local sign_color="\[\e[0;38;5;57m\]"
        local directory_color="\[\e[0;38;5;50m\]"
        local white_color="\[\e[0m\]"

        local time_part="$time_color\T"
        local user_part="$user_host_color\u"
        local host_part="$user_host_color\H"
        local user_host_part="$user_part$sign_color@$host_part"
        local directory_part="$directory_color\w"
        local command_part="$sign_color\$$white_color"

        PS1="$time_part $user_host_part $directory_part\n$command_part "
}
prompt
