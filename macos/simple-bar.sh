#!/usr/bin/env bash

export GUM_CHOOSE_SHOW_HELP=0
choice=$(gum choose "Top" "Bottom")
configfile="$HOME/.simplebarrc"

echo "$choice"

case $choice in
Top*)
    gsed -i 's/"bottomBar": true,/"bottomBar": false,/' "$configfile"
    osascript -e 'tell application id "tracesOf.Uebersicht" to refresh'
    yabai -m config external_bar all:28:0
    ;;
Bottom*)
    gsed -i 's/"bottomBar": false,/"bottomBar": true,/' "$configfile"
    osascript -e 'tell application id "tracesOf.Uebersicht" to refresh'
    yabai -m config external_bar all:0:28
    ;;
esac
