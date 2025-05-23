#!/usr/bin/env bash

export PURPLE=#4137ff
export BLUE=#4c91ff

export GUM_CHOOSE_CURSOR_FOREGROUND=$PURPLE
export GUM_CHOOSE_HEADER_FOREGROUND=$BLUE
export GUM_CHOOSE_SELECTED_FOREGROUND=$PURPLE
export GUM_CHOOSE_SHOW_HELP=0

choice=$(gum choose "Top" "Bottom")
configfile="$HOME/.simplebarrc"

echo "$choice"

bar_height=$(jq -r .customStyles[] "$configfile" | grep bar-height | grep -o '[0-9]*')

# set -x
case $choice in
Top*)
    gsed -i 's/"bottomBar": true,/"bottomBar": false,/' "$configfile"
    gsed -i 's/"compactMode": false,/"compactMode": true,/' "$configfile"
    osascript -e 'tell application id "tracesOf.Uebersicht" to refresh'
    # yabai -m config external_bar all:32:0
    # yabai -m config external_bar all:64:0
    yabai -m config external_bar "all:${bar_height}:0"
    ;;
Bottom*)
    gsed -i 's/"bottomBar": false,/"bottomBar": true,/' "$configfile"
    gsed -i 's/"compactMode": false,/"compactMode": true,/' "$configfile"
    osascript -e 'tell application id "tracesOf.Uebersicht" to refresh'
    # yabai -m config external_bar all:0:34
    # yabai -m config external_bar all:0:64
    yabai -m config external_bar "all:0:${bar_height}"
    ;;
esac
