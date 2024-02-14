#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
	echo "Please provide a hostname to create a key for"
	exit
fi

KEY=$1
CA_NAME="ca_signing"

read -p "Continue with creating key $KEY? " go

case $go in
[Yy]*)
	echo "Creating key..."

	read -p "Nickname for $KEY? " nick

	openssl rand -out noise.bin 2048

	certutil -S \
		-d nssdb \
		-f password.txt \
		-z noise.bin \
		-c $CA_NAME \
		-s "CN=${KEY}.Skynet" \
		-n $nick \
		-g 2048 \
		-v 12 \
		-t ",," \
		-1 digitalSignature,nonRepudiation,dataEncipherment \
		-6 clientAuth,ipsecIKE,ipsecTunnel,ipsecUser

	certutil -d nssdb -L -n $nick -a >>"${KEY%%.*}.crt"
	;;

esac

# not supported by pfsense
#           -5 sslClient \
