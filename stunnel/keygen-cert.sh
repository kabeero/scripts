if [[ $# -gt 0 ]]; then
	echo "Creating certificate for" $1 ".stryker.com"
	CACERT=ultra_ca_cert.pem
	CAKEY=ultra_ca_key.pem
	KEYDIR="private/"
	CERTDIR="./"
    openssl genrsa -out $KEYDIR$1_key.pem 4096
    openssl req -new \
                -key $KEYDIR$1_key.pem \
                -out $CERTDIR$1_cert.req \
                -subj "/C=US/ST=Michigan/L=Kalamazoo/O=Stryker/OU=Instruments/CN=${1}.stryker.com"
    openssl x509 -req -days 365 -in $CERTDIR$1_cert.req -CA $CERTDIR$CACERT -CAkey $KEYDIR$CAKEY -CAcreateserial -out $CERTDIR$1_cert.pem
    rm $CERTDIR$1_cert.req
    rm .srl
    c_rehash $CERTDIR
    # needs to have public key
    # cat $KEYDIR$1_key.pem $CERTDIR$1_cert.pem >> $KEYDIR$1.pem
else
    echo "Please provide a machine name to create a certificate request for"
fi;
