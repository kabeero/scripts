#!/usr/bin/env sh

if [[ $# -eq 1 ]]; then
    select=$(echo $1 | grep -oE "^[0-9]")
else
    monitors=("1) Single monitor" "2) Dual monitor" "3) Triple monitor")
    IFS="\\"
    select=$(gum choose ${monitors[@]} | grep -oE "^[0-9]")
fi

echo $select

if [[ $select == "1" ]]; then
    xrandr --output DP-0 --rotate left --auto
    xrandr --output DP-2 --off
    xrandr --output DP-4 --off
elif [[ $select == "2" ]]; then
    xrandr --output DP-0 --rotate left --auto
    xrandr --output DP-2 --rotate left --auto --left-of DP-0
    xrandr --output DP-4 --off
elif [[ $select == "3" ]]; then
    xrandr --output DP-0 --rotate left --auto
    xrandr --output DP-4 --rotate right --auto --left-of DP-0
    xrandr --output DP-2 --rotate left --auto --left-of DP-4
fi
