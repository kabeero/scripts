#!/usr/bin/env bash

set -eou pipefail

if [ ! -x "$(command -v xwininfo)" ]; then
    echo "Please install xwininfo"
    exit 1
fi

if [ ! -x "$(command -v recordmydesktop)" ]; then
    echo "Please install recordmydesktop"
    exit 1
fi

xwininfo | grep -i id | grep -oE "0x[a-z0-9]+" | \
    xargs -i{} recordmydesktop --no-sound --fps=60 --windowid={}
