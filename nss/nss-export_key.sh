#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
	echo "Please provide a nick to export a key for"
	exit
fi

KEY=$1

read -p "Continue with creating key $KEY? " go

case $go in
	[Yy]* ) 
		echo "Creating key for $KEY..."

		read -sp "Please enter new p12 password: " PASS
		echo

		pk12util -d nssdb -n $KEY -W ${PASS} -o "${KEY}.p12"

		openssl pkcs12 -nocerts -in "${KEY}.p12" -passin pass:${PASS} -passout pass:${PASS} | \
			awk '(NR>4){print}' >> "${KEY}.pem"

		openssl pkcs12 -clcerts -nokeys -in "${KEY}.p12" -passin pass:${PASS} -passout pass:${PASS} | \
			awk '(NR>7){print}' >> "${KEY}.crt"

		rm "${KEY}.p12"
esac
