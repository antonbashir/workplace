function prompt_label() {
    if [[ $(id -u) -ne 0 ]] ; then
        local time_color="\[\e[0;38;5;27m\]"
        local user_host_color="\[\e[0;38;5;39m\]"
        local sign_color="\[\e[0;38;5;57m\]"
        local directory_color="\[\e[0;38;5;50m\]"
        local white_color="\[\e[0m\]"
        local git_color="\[\e[0;38;5;156m\]"
        local architecture_color="\[\e[0;38;5;134m\]"
        local kubeprompt_color="\[\e[0;38;5;96m\]"

        local time_part="$time_color\T"
        local user_part="$user_host_color\u"
        local host_part="$user_host_color\H"
        local user_host_part="$user_part$sign_color@$host_part"
        local directory_part="$directory_color\w"
        local architecture_part="$architecture_color$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)-$(uname -m)"
        local command_part="$sign_color($(echo -e '🦊'))$white_color"

        PS1="$time_part $user_host_part $architecture_part $directory_part$git_color\$GIT_BRANCH\n$kubeprompt_color\$KUBEPROMPT\n$command_part "
    else

        local time_color="\[\e[0;38;5;27m\]"
        local user_host_color="\[\e[0;38;5;39m\]"
        local sign_color="\[\e[0;38;5;160m\]"
        local directory_color="\[\e[0;38;5;50m\]"
        local white_color="\[\e[0m\]"
        local git_color="\[\e[0;38;5;156m\]"
        local architecture_color="\[\e[0;38;5;134m\]"
        local kubeprompt_color="\[\e[0;38;5;96m\]"

        local time_part="$time_color\T"
        local user_part="$user_host_color\u"
        local host_part="$user_host_color\H"
        local user_host_part="$user_part$sign_color@$host_part"
        local architecture_part="$architecture_color$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)-$(uname -m)"
        local directory_part="$directory_color\w"
        local command_part="$sign_color($(echo -e '🐺'))$white_color"

        PS1="$time_part $user_host_part $architecture_part $directory_part$git_color\$GIT_BRANCH\n$kubeprompt_color\$KUBEPROMPT\n$command_part "
    fi
}

function prompt_command() {
        export GIT_BRANCH=""
        if [ -f "/usr/bin/git" ]; then
              current_directory=`pwd`
              while [[ "`pwd`" != '/' ]]; do
                  if [[ -d "$(pwd)/.git" ]]; then
                      export GIT_BRANCH=" $(git branch --show-current)"
                    break
                  fi
                  cd ..
                done
                cd "$current_directory"
        fi
        if [ -f "/usr/bin/kubeprompt" ]; then
              export GIT_BRANCH=" $(git branch --show-current)"
	      export KUBEPROMPT=" $(kubeprompt -f default)"
        fi
}

PROMPT_COMMAND=prompt_command
prompt_label
