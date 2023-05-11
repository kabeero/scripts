#!/usr/bin/env sh

echo
echo "Forcing +dpms"

while true; do
    sleep 60
    xset +dpms
done
