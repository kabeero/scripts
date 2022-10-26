#!/usr/bin/env bash

file="$HOME/screenshot-$(date +"%Y_%m_%d-%H_%M_%S").png"

echo "📸 Saving screenshot to $file"

trap "rm $file; exit" 1 2 3 6

maim -uso $file

if [[ $? -eq 0 ]]; then
    cat $file | xclip -selection clipboard -t image/png
else
    rm $file
fi
