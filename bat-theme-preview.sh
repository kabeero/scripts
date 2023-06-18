#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo
    echo "Please provide an input file to preview"
    exit
fi

bat --list-themes | fzf --preview="bat --theme={} --color=always $1"
