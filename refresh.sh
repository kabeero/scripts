#!/usr/bin/env bash

rate=$(xrandr | grep -C1 "eDP-1" | grep -Eo "[0-9.]+\*")

new_rate=$(gum choose "60" "165" --header "Current refresh rate: ${rate}")

if [[ -z $new_rate ]]; then
    exit 1
fi

xrandr --output eDP-1 \
       --mode 2560x1600 \
       --rate $new_rate
