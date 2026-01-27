#!/usr/bin/env sh

# Alphanumeric with openssl
# openssl rand -base64 15 | tr -d "+=/" | cut -c1-15

# urandom seeded password with letters, numbers, and symbols
# locale: don't use multibyte encoding
LC_ALL=C </dev/urandom tr -dc 'A-Za-z0-9@#$%^&*()!~`"\'':;.,?={}|<>[]' | fold -w 15 | head -n 1
