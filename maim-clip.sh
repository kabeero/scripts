#!/usr/bin/env sh
file=$(mktemp ~/screenshot-XXXXX.png)
trap "rm $file; exit" 1 2 3 6
maim -uso $file
if [[ $? -eq 0 ]]; then
    cat $file | xclip -selection clipboard -t image/png
else
    rm $file
fi
