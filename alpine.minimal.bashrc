[ -z "$PS1" ] && return

alias ll='ls -alt --color=always'
alias rm='rm -rf'
alias apt='sudo aptitude'
alias transfer='rsync -ah --info=progress2'
alias pack='tar -cpf'
alias unpack='tar -xpf'
alias mount='mount | column -t'
alias path='echo -e ${PATH//:/\\n}'
alias tree='tree -Ca'
alias root='sudo -i'
alias download="wget -N"
alias occupied='du -d 1 -h'

dir() {
        mkdir -p $1
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


function prompt_label() {
        local time_color="\[\e[0;38;5;27m\]"
        local user_host_color="\[\e[0;38;5;39m\]"
        local sign_color="\[\e[0;38;5;57m\]"
        local directory_color="\[\e[0;38;5;50m\]"
        local white_color="\[\e[0m\]"
        local git_color="\[\e[0;38;5;156m\]"
        local architecture_color="\[\e[0;38;5;134m\]"

        local time_part="$time_color\T"
        local user_part="$user_host_color\u"
        local host_part="$user_host_color\H"
        local user_host_part="$user_part$sign_color@$host_part"
        local directory_part="$directory_color\w"
        local architecture_part="$architecture_color$(dpkg --print-architecture)"
        local command_part="$sign_color($(echo -e '🦊'))$white_color"

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
