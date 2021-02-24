if [[ $# -gt 0 ]]; then
    openssl genrsa -out $1_key.pem 4096
    openssl req -new \
                -key $1_key.pem \
                -out $1_cert.req \
                -subj "/C=US/ST=State/L=Location/O=Organization/OU=Division/CN=${1}.domain.com"
else
    echo "Please provide a machine name to create a certificate request for"
fi;
