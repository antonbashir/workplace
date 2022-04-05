#!/bin/bash

[ -z "$PS1" ] && return
shopt -s checkwinsize
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -x /usr/lib/command-not-found ] && [ -x /usr/share/command-not-found/command-not-found ]; then
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

systemUser() {
        useradd --system --no-create-home -s /sbin/nologin $1
}

toUnix() {
        find $1 -type f -print0 | xargs -0 dos2unix
}

certificate() {
        openssl req -x509 -newkey rsa:4096 -keyout $1.key -out $1.cert -sha256 -days 365 -nodes -subj '/CN=$2'
}


. "$HOME/.bashrc.d/host/vm.sh"
. "$HOME/.bashrc.d/common/aliases.sh"
. "$HOME/.bashrc.d/common/functions.sh"
. "$HOME/.bashrc.d/common/prompt.sh"
