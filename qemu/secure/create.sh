KEY_OUT="oem.key"
PEM_OUT="oem.pem"
OEM_OUT="oem.str"

openssl req -x509 -newkey rsa:2048 -outform PEM -keyout oem.key -out oem.pem

cat ${PEM_OUT} | sed -e 's/^-----BEGIN CERTIFICATE-----$/4e32566d-8e9e-4f52-81d3-5bb9715f9727:/' -e '/^-----END CERTIFICATE-----$/d' | tr -d '\n' > ${OEM_OUT}
