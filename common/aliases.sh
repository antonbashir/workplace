#!/bin/bash

alias ll='ls -alt'
alias rm='rm -rf'
alias transfer='rsync -ah'
alias pack='tar -cpf'
alias unpack='tar -xpf'
alias mount='mount'
alias path='echo -e ${PATH//:/\\n}'
alias tree='tree -Ca'
alias root='sudo -i'
alias download="wget -N"
alias occupied='du -d 1 -h'
alias traffic='sudo iftop'
alias process='ps aux | grep'


if [ "$(uname)" == "Darwin" ]; then
  alias package='brew'
fi

if [ -f /etc/os-release ]; then
  if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "alpine" ]; then
    alias package='sudo apk'
  fi

  if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "debian" ]; then
    alias package='sudo aptitude'
  fi
fi
