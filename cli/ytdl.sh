#!/usr/bin/env bash

if ! command -v yt-dlp &>/dev/null; then
    echo "Please install yt-dlp"
    exit 1
fi

if [[ $# -ne 1 ]]; then
    echo "Usage: ${0} URL"
    exit 1
fi

yt-dlp \
    -o "%(title)s.$(ext)s" \
    --write-subs \
    --sub-langs en \
    --embed subs \
    $1
