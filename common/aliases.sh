#!/bin/bash

alias ll='ls -alt --color=always'
alias rm='rm -rf'
alias transfer='rsync -ah --info=progress2'
alias pack='tar -cpf'
alias unpack='tar -xpf'
alias mount='mount | column -t'
alias path='echo -e ${PATH//:/\\n}'
alias tree='tree -Ca'
alias root='sudo -i'
alias download="wget -N"
alias occupied='du -d 1 -h'
alias files='files -d -e -H'
alias traffic='sudo iftop'
alias process='ps aux | grep'


if [ "$(uname)" == "Darwin" ]; then
  alias package='sudo brew'
fi

if [ -f /etc/os-release ]; then
  if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "alpine" ]; then
    alias package='sudo apk'
  fi

  if [ $(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release) == "debian" ]; then
    alias package='sudo aptitude'
  fi
fi
