#!/usr/bin/env bash

choice=$(gum choose "With padding" "No padding")

echo "$choice"

if [[ "$choice" =~ "abort" ]]; then
    exit 1
fi

case $choice in
abort*)
    exit 1
    ;;
With*)
    yabai -m config top_padding 8
    ;;
No*)
    yabai -m config top_padding 0
    ;;
esac
