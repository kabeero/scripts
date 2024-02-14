# echo Secret.123 > password.txt

openssl rand -out noise.bin 2048

mkdir nssdb

certutil -N -d nssdb -f password.txt
