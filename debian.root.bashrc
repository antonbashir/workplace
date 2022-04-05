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
alias apt='aptitude'
alias transfer='rsync -ah --info=progress2'
alias pack='tar -cpf'
alias unpack='tar -xpf'
alias mount='mount | column -t'
alias path='echo -e ${PATH//:/\\n}'
alias tree='tree -Ca'
alias download="wget -N"
alias occupied='du -d 1 -h'
alias files='files -d -e -H -r'
alias traffic='sudo iftop'

systemUser() {
        useradd --system --no-create-home -s /sbin/nologin $1
}

toUnix() {
        find $1 -type f -print0 | xargs -0 dos2unix
}

certificate() {
        openssl req -x509 -newkey rsa:4096 -keyout $1.key -out $1.cert -sha256 -days 365 -nodes -subj '/CN=$2'
}

prepare() {
        apt install -y wget rsync tar aptitude iproute2 iftop
}

vm() {
        if [ "$1" == "new" ]; then
                if [ "$2" == "debian" ]; then
                        lxc-create -t download -n $3 -- --no-validate -d debian -r bullseye -a amd64
                        return
                fi

                if [ "$2" == "alpine" ]; then
                        lxc-create -t download -n $3 -- --no-validate -d alpine -r edge -a amd64
                        return
                fi
                return
        fi

        if [ "$1" == "forward" ]; then
                iptables --table nat --append PREROUTING -p tcp -i eth0 -m tcp --dport $2 -j DNAT --to-destination $(lxc-info -n $3 -iH)
                iptables --table nat --append PREROUTING -p udp -i eth0 -m udp --dport $2 -j DNAT --to-destination $(lxc-info -n $3 -iH)
                return
        fi

        if [ "$1" == "shell" ]; then
                 lxc-attach -n $2
                return
        fi

        if [ "$1" == "start" ]; then
                 lxc-start -n $2
                return
        fi

        if [ "$1" == "stop" ]; then
                 lxc-stop -n $2 -k
                return
        fi

        if [ "$1" == "rm" ]; then
                 lxc-destroy -n $2
                 return
        fi

        if [ "$1" == "pack" ]; then
                lxc-stop -n $2 -k > /dev/null 2>&1
                current=$(pwd)
                user=$USER
                bash -c "cd /var/lib/lxc/$2/rootfs && tar --numeric-owner -cpf $current/$3 ./* && chown -R $user:$user $current/$3"
                lxc-start -n $2 > /dev/null 2>&1
                return
        fi

        if [ "$1" == "ip" ]; then
                sudo lxc-info -n $2 -iH
                return
        fi

        if [ "$1" == "unpack" ]; then
                lxc-stop -n $2 -k > /dev/null 2>&1
                bash -c "rm -rf /var/lib/lxc/$2/rootfs/*"
                bash -c "tar --numeric-owner -xpf $3 -C /var/lib/lxc/$2/rootfs"
                lxc-start -n $2 > /dev/null 2>&1
                return
        fi

        if [ "$1" == "configure" ]; then
           apt install -y lxc lxcfs lxc-templates

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

        cp configure-dns /etc/lxc/dnsmasq.conf        
        cp configure-lxc-config /etc/lxc/default.conf
        cp configure-lxc-default /etc/default/lxc

        rm configure-dns
        rm configure-lxc-config
        rm configure-lxc-default

        service lxc-net restart
        return
        fi

         lxc-ls -f
}

dir() {
        if [ ! -d "$1" ]; then
                mkdir -p $1
        fi
}

own() {
         chown -R $1:$1 $2
}

toExecutable() {
         chmod +x $1
}

toFile() {
         chmod 0644 $1
}

toDir() {
         chmod 755 $1
}


function prompt_label() {
        local time_color="\[\e[0;38;5;27m\]"
        local user_host_color="\[\e[0;38;5;39m\]"
        local sign_color="\[\e[0;38;5;160m\]"
        local directory_color="\[\e[0;38;5;50m\]"
        local white_color="\[\e[0m\]"
        local git_color="\[\e[0;38;5;156m\]"
        local architecture_color="\[\e[0;38;5;134m\]"
        
        local time_part="$time_color\T"
        local user_part="$user_host_color\u"
        local host_part="$user_host_color\H"
        local user_host_part="$user_part$sign_color@$host_part"
        local architecture_part="$architecture_color$(dpkg --print-architecture)"
        local directory_part="$directory_color\w"
        local command_part="$sign_color($(echo -e '🐺'))$white_color"

        PS1="$time_part $user_host_part $architecture_part $directory_part$git_color\$GIT_BRANCH\n$command_part "
}

function prompt_command() {
        if [ -f "/usr/bin/git" ] && [ -d "$(pwd)/.git" ]; then
                export GIT_BRANCH=" $(git branch --show-current)"
        else
                export GIT_BRANCH=""
        fi
}

PROMPT_COMMAND=prompt_command
prompt_label
