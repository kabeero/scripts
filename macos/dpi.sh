#!/usr/bin/env bash

if ! command -v displayplacer >/dev/null; then
    echo "please install displayplacer"
    exit 1
fi

desired="res:3024x1964.*hz:120"
display_id=$(displayplacer list | grep -B3 "MacBook" | grep "Persistent" | awk '{print $NF}')
modeline=$(displayplacer list | grep "$desired")
mode=$(echo "$modeline" | awk '{print $2}' | tr -d ':')
echo "modeline detected: ${modeline}"
echo "mode detected: ${mode}"
set -x
displayplacer "id:${display_id} mode:${mode}"
