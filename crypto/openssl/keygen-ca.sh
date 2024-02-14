# only ran once : create the certificate authority file
# will ask for a password
openssl req -x509 \
            -days 3650 \
            -newkey rsa:4096 \
            -keyout server_ca_key.pem \
            -out server_ca_cert.pem \
            -subj "/C=US/ST=State/L=Location/O=Organization/OU=Division/CN=server.domain.com"
