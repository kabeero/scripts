openssl x509 -req -days 365 -in server_cert.req -CA server_ca_cert.pem -CAkey server_ca_key.pem -CAcreateserial -out server_cert.pem
