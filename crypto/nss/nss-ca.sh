#!/usr/bin/env bash

openssl rand -out noise.bin 2048

CA_SKID="0x`openssl rand -hex 20`"

OCSP="http://$HOSTNAME:8080/ca/ocsp"

echo -e "y\n\ny\ny\n${CA_SKID}\n\n\n\n${CA_SKID}\n\n2\n7\n${OCSP}\n\n\n\n" | \
certutil -S \
	-x \
	-d nssdb \
	-f password.txt \
	-z noise.bin \
	-n ca_signing \
	-s "CN=Certificate Authority,O=Skynet" \
	-t "CT,C,C" \
	-m $RANDOM \
	-k rsa \
	-g 2048 \
	-Z SHA256 \
	-2 \
	-3 \
	--keyUsage critical,certSigning,crlSigning,digitalSignature,nonRepudiation \
	--extAIA \
	--extSKID

certutil -L -d nssdb -n ca_signing -a > ca_signing.crt
