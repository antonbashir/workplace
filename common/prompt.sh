_prompt_label() {
	if [[ $(id -u) -ne 0 ]]; then
		local time_color="\[\e[0;38;5;27m\]"
		local user_host_color="\[\e[0;38;5;39m\]"
		local sign_color="\[\e[0;38;5;57m\]"
		local directory_color="\[\e[0;38;5;50m\]"
		local white_color="\[\e[0m\]"
		local git_color="\[\e[0;38;5;156m\]"
		local architecture_color="\[\e[0;38;5;134m\]"

		local time_part="$time_color\t"
		local user_part="$user_host_color\u"
		local host_part="$user_host_color\H"
		local user_host_part="$user_part$sign_color@$host_part"
		local directory_part="$directory_color\w"
		local architecture_part=""

		if [[ "$(uname)" == "Darwin" ]]; then
			local architecture_part="$architecture_color$(echo osx-$(uname -m))"
		fi

		if [[ -f /etc/os-release ]]; then
			local architecture_part="$architecture_color$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)-$(uname -m)"
		fi

		local command_part="$sign_color($(echo -e '🦊'))$white_color"

		PS1="$time_part $user_host_part $architecture_part $directory_part$git_color\$GIT_BRANCH\n$command_part "
	else
		local time_color="\[\e[0;38;5;27m\]"
		local user_host_color="\[\e[0;38;5;39m\]"
		local sign_color="\[\e[0;38;5;160m\]"
		local directory_color="\[\e[0;38;5;50m\]"
		local white_color="\[\e[0m\]"
		local git_color="\[\e[0;38;5;156m\]"
		local architecture_color="\[\e[0;38;5;134m\]"

		local time_part="$time_color\t"
		local user_part="$user_host_color\u"
		local host_part="$user_host_color\H"
		local user_host_part="$user_part$sign_color@$host_part"
		local architecture_part=""

		if [[ "$(uname)" == "Darwin" ]]; then
			local architecture_part="$architecture_color$(echo osx-$(uname -m))"
		fi

		if [[ -f /etc/os-release ]]; then
			local architecture_part="$architecture_color$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)-$(uname -m)"
		fi

		local directory_part="$directory_color\w"
		local command_part="$sign_color($(echo -e '🐺'))$white_color"

		PS1="$time_part $user_host_part $architecture_part $directory_part$git_color\$GIT_BRANCH\n$command_part "
	fi
}

_git_prompt() {
	export GIT_BRANCH=""
	if [[ -f "/usr/bin/git" ]]; then
		local current_directory=$(pwd)
		while [[ "$current_directory" != '/' ]]; do
			if [[ -d "$current_directory/.git" ]]; then
				export GIT_BRANCH=" $(git branch --show-current)"
				break
			fi
			current_directory="$(dirname "$current_directory")"
		done
	fi
}

_register_git_prompt() {
	if [[ "$(declare -p PROMPT_COMMAND 2>/dev/null)" == "declare -a"* ]]; then
		if [[ " ${PROMPT_COMMAND[*]} " != *" _git_prompt "* ]]; then
			PROMPT_COMMAND=("_git_prompt" "${PROMPT_COMMAND[@]}")
		fi
		return
	fi
	if [[ ";${PROMPT_COMMAND:-};" != *";_git_prompt;"* ]]; then
		local _git_prompt_value="${PROMPT_COMMAND-}"
		printf -v PROMPT_COMMAND '%s' "_git_prompt${_git_prompt_value:+;$_git_prompt_value}"
	fi
}

_register_git_prompt

_prompt_label
