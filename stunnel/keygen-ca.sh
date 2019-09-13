# only ran once : create the certificate authority file
# will ask for a password
openssl req -x509 \
            -days 3650 \
            -newkey rsa:4096 \
            -keyout ultra_ca_key.pem \
            -out ultra_ca_cert.pem \
            -subj "/C=US/ST=Michigan/L=Kalamazoo/O=Stryker/OU=Instruments/CN=ultra.stryker.com"
