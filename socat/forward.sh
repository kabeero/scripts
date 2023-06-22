#!/usr/bin/env bash

set -euo pipefail

LAN_SUBNET=10.0.0.0/8
LISTEN_PORT=12345
REMOTE_HOST=HOST
REMOTE_PORT=4321

# if connecting with to proxy with `ssh -nNfL`
socat TCP4-LISTEN:${LISTEN_PORT},bind=127.0.0.1,reuseaddr,fork TCP4:${REMOTE_HOST}:${REMOTE_PORT} &

# if serving proxy on LAN
# socat TCP4-LISTEN:${LISTEN_PORT},bind=0.0.0.0,reuseaddr,fork,range=${LAN_SUBNET} TCP4:localhost:${REMOTE_PORT},bind=127.0.0.1 &
