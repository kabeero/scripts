#!/usr/bin/env bash

if [[ $# -eq 1 ]] ; then
    cat ${1} | xargs -n2 -P4 yt-dlp -o
fi
