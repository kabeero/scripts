#!/usr/bin/env bash

export GUM_CHOOSE_SHOW_HELP=0
choice=$(gum choose "With padding" "No padding")

echo "$choice"

case $choice in
With*)
    yabai -m config top_padding 8
    ;;
No*)
    yabai -m config top_padding 0
    ;;
esac
