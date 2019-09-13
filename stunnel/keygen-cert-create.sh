openssl x509 -req -days 365 -in ultra_cert.req -CA ultra_ca_cert.pem -CAkey ultra_ca_key.pem -CAcreateserial -out ultra_cert.pem
