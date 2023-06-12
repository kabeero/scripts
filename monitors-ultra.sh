#!/usr/bin/env sh
xrandr --output DP-2 --auto --rotate left
xrandr --output DP-0 --auto --rotate left --left-of DP-2
xrandr --output DP-4 --auto --rotate right --right-of DP-2
nitrogen --restore
