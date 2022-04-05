#!/bin/bash

bash -c "$(pwd)/bootstrap.$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release).sh"
