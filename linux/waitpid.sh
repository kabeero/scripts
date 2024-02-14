#!/usr/bin/env sh
while [ -e /proc/$1 ]; do sleep 1; done
