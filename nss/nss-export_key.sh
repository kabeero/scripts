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

		# encrypted private key
		openssl pkcs12 -nocerts -in "${KEY}.p12" -passin pass:${PASS} -passout pass:${PASS} | \
			awk '(NR>4){print}' >> "${KEY}.pem"

		# plaintext private key
		#openssl pkcs12 -nocerts -nodes -in "${KEY}.p12" -passin pass:${PASS} -passout pass:${PASS} | \
		#	awk '(NR>4){print}' >> "${KEY}.pem"

		openssl rsa -in ${KEY}.pem -pubout -passin pass:${PASS} -passout pass:${PASS} >> ${KEY}.pub

		openssl pkcs12 -clcerts -nokeys -in "${KEY}.p12" -passin pass:${PASS} -passout pass:${PASS} | \
			awk '(NR>7){print}' >> "${KEY}.crt"

		openssl pkcs12 -cacerts -nokeys -in "${KEY}.p12" -passin pass:${PASS} -passout pass:${PASS} | \
			awk '(NR>6){print}' >> "${KEY}.ca"

		read -p "Keep p12 key ${KEY}.p12? " go
		
		case $go in
			[Nn]* ) rm "${KEY}.p12"
		esac
esac
