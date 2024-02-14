# Move to root directory...
cd /
mkdir keys
cd keys

# Generate a self signed certificate for the CA along with a key.
mkdir -p ca/private
chmod 700 ca/private
# NOTE: I'm using -nodes, this means that once anybody gets
# their hands on this particular certificate they can become this CA.
openssl req \
    -x509 \
    -nodes \
    -days 3650 \
    -newkey rsa:4096 \
    -keyout ca/private/ca_key.pem \
    -out ca/ca_cert.pem \
    -subj "/C=US/ST=Acme State/L=Acme City/O=Acme Inc./CN=example.com"

# Create server private key and certificate request
mkdir -p server/private
chmod 700 ca/private
openssl genrsa -out server/private/server_key.pem 4096
openssl req -new \
    -key server/private/server_key.pem \
    -out server/server.csr \
    -subj "/C=US/ST=Acme State/L=Acme City/O=Acme Inc./CN=server.example.com"

# Create client private key and certificate request
mkdir -p client/private
chmod 700 client/private
openssl genrsa -out client/private/client_key.pem 4096
openssl req -new \
    -key client/private/client_key.pem \
    -out client/client.csr \
    -subj "/C=US/ST=Acme State/L=Acme City/O=Acme Inc./CN=client.example.com"

# Generate certificates
openssl x509 -req -days 1460 -in server/server.csr \
    -CA ca/ca_cert.pem -CAkey ca/private/ca_key.pem \
    -CAcreateserial -out server/server_cert.pem
openssl x509 -req -days 1460 -in client/client.csr \
    -CA ca/ca_cert.pem -CAkey ca/private/ca_key.pem \
    -CAcreateserial -out client/client_cert.pem

# Now test both the server and the client
# On one shell, run the following
openssl s_server -CAfile ca/ca_cert.pem -cert server/server_cert.pem -key server/private/server_key.pem -Verify 1
# On another shell, run the following
openssl s_client -CAfile ca/ca_cert.pem -cert client/client_cert.pem -key client/private/client_key.pem
# Once the negotiation is complete, any line you type is sent over to the other side.
# By line, I mean some text followed by a keyboar return press.

# stunnel.org / howto

openssl req -new -x509 -days 365 -nodes -config stunnel.cnf -out stunnel.pem -keyout stunnel.pem

This creates a private key, and self-signed certificate. The arguments mean:

-days 365
    make this key valid for 1 year, after which it is not to be used any more
-new
    Generate a new key
-x509
    Generate an X509 certificate (self sign)
-nodes
    Do not put a password on this key.
-config `stunnel.cnf`
    the OpenSSL configuration file to use
-out `stunnel.pem`
    where to put the SSL certificate
-keyout `stunnel.pem`
    put the key in this file

# verify modes

    verify = 1
        Verify the certificate, if present.
            If no certificate is presented by the remote end, accept the connection.
            If a certificate is presented, then
                If the certificate valid, it will log which certificate is being used, and continue the connection.
                If the certificate is invalid, it will drop the connection.

    verify = 2
        Require and verify certificates

        Stunnel will require and verify certificates for every SSL connection. If no certificate or an invalid certificate is presented, then it will drop the connection.

    verify = 3
        Require and verify certificates against locally installed certificates.

