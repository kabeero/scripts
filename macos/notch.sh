#!/usr/bin/env bash

export PURPLE=#4137ff
export BLUE=#4c91ff

export GUM_CHOOSE_CURSOR_FOREGROUND=$PURPLE
export GUM_CHOOSE_HEADER_FOREGROUND=$BLUE
export GUM_CHOOSE_SELECTED_FOREGROUND=$PURPLE
export GUM_CHOOSE_SHOW_HELP=0

choice=$(gum choose "With padding" "No padding")
configfile="$HOME/.simplebarrc"

echo "$choice"

outer_padding=$(grep gap "${HOME}/.config/yabai/yabairc" | grep -o '[1-9][0-9]*')

# set -x
case $choice in
With*)
    yabai -m config top_padding "$outer_padding"
    gsed -i 's/"compactMode": false,/"compactMode": true,/' "$configfile"
    osascript -e 'tell application id "tracesOf.Uebersicht" to refresh'
    ;;
No*)
    yabai -m config top_padding 0
    gsed -i 's/"compactMode": true,/"compactMode": false,/' "$configfile"
    osascript -e 'tell application id "tracesOf.Uebersicht" to refresh'
    ;;
esac
