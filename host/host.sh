#!/bin/bash

[[ -z "$PS1" ]] && return

if [[ "$(uname)" != "Darwin" ]]; then
	shopt -s checkwinsize
	if [[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]]; then
		debian_chroot=$(cat /etc/debian_chroot)
	fi
	if [[ -x /usr/lib/command-not-found ]] && [[ -x /usr/share/command-not-found/command-not-found ]]; then
		function command_not_found_handle {
			if [[ -x /usr/lib/command-not-found ]]; then
				/usr/lib/command-not-found -- "$1"
				return $?
			elif [[ -x /usr/share/command-not-found/command-not-found ]]; then
				/usr/share/command-not-found/command-not-found -- "$1"
				return $?
			else
				printf "%s: command not found\n" "$1" >&2
				return 127
			fi
		}
	fi
	. "$HOME/.profile.d/host/vm.sh"
	eval "$(fzf --bash)"
fi

. "$HOME/.profile.d/common/aliases.sh"
. "$HOME/.profile.d/common/functions.sh"
. "$HOME/.profile.d/common/prompt.sh"
