#!/bin/bash

dir() {
	mkdir -p $1
}

own() {
	sudo chown -R $1:$1 $2
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

toUnix() {
	find $1 -type f -print0 | xargs -0 dos2unix
}

reload() {
	cd "$HOME/.profile.d" && git pull
}

status() {
	python $HOME/.profile.d/common/status.py $1
}

createSystemUser() {
	useradd --system --no-create-home -s /sbin/nologin $1
}

generateCertificate() {
	openssl req -x509 -newkey rsa:4096 -keyout $1.key -out $1.cert -sha256 -days 365 -nodes -subj '/CN=$2'
}
