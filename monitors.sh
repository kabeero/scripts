#!/usr/bin/env bash

# DP-0: right (left)
# DP-2: middle (right)
# DP-4: left (left)

if ! command -v gum &>/dev/null; then
	echo
	echo >&2 "Please install gum"
	echo
	exit 1
fi

if [[ $# -eq 1 ]]; then
	select=$(echo $1 | grep -oE "^[0-9]")
else
	monitors=("1) Single monitor" "2) Dual monitor" "3) Triple monitor")
	IFS="\\"
	select=$(gum choose ${monitors[@]} | grep -oE "^[0-9]")
fi

echo $select

# nvidia
# INPUT1="DP-0"
# INPUT2="DP-2"
# INPUT3="DP-4"

# amdgpu
INPUT1="DisplayPort-0"
INPUT2="DisplayPort-1"
INPUT3="DisplayPort-2"

if [[ $select == "1" ]]; then
	xrandr --output "$INPUT1" --rotate left --auto
	xrandr --output "$INPUT2" --off
	xrandr --output "$INPUT3" --off
elif [[ $select == "2" ]]; then
	xrandr --output "$INPUT1" --rotate left --auto
	xrandr --output "$INPUT2" --rotate right --auto --left-of "$INPUT1"
	xrandr --output "$INPUT3" --off
elif [[ $select == "3" ]]; then
	xrandr --output "$INPUT1" --rotate left --auto
	xrandr --output "$INPUT2" --rotate right --auto --left-of "$INPUT1"
	xrandr --output "$INPUT3" --rotate left --auto --left-of "$INPUT2"
fi
