#!/usr/bin/env bash

if [[ $# -eq 0 ]] ; then
    DL="dl.txt"
else
    DL=$1
fi

cat $DL | xargs -n2 -P4 yt-dlp -o
