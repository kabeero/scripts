#!/usr/bin/env bash

# DP-0: left (left)
# DP-2: middle (left)
# DP-4: right (right)

if ! command -v gum &> /dev/null ; then
    echo
    echo >&2 "Please install gum"
    echo
    exit 1
fi

if [[ $# -eq 1 ]]; then
    select=$(echo $1 | grep -oE "^[0-9]")
else
    monitors=("1) Single monitor" "2) Dual monitor" "3) Triple monitor" "4) Unify")
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
    xrandr --output DP-2 --rotate left --auto --right-of DP-0
    xrandr --output DP-4 --off
elif [[ $select == "3" ]]; then
    xrandr --output DP-0 --rotate left --auto
    xrandr --output DP-2 --rotate left --auto --right-of DP-0
    xrandr --output DP-4 --rotate right --auto --right-of DP-2
elif [[ $select == "4" ]]; then
    xrandr --output DP-0 --rotate left --auto
    xrandr --output DP-2 --rotate left --auto --right-of DP-0
    xrandr --output DP-4 --rotate right --auto --right-of DP-2
    sleep 1
    xrandr --setmonitor Dual auto DP-2,DP-4
    sleep 1
    i3-msg restart
fi

sleep 1
nitrogen --restore
