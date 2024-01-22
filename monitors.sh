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
	echo
	echo "🖵  Detected displays"
	echo
	displays=$(xrandr | grep " connected" | awk {'print $1'})
	for d in ${displays[@]}; do
		echo "  $d"
	done
	echo
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
# INPUT1="DisplayPort-0"
# INPUT2="DisplayPort-1"
# INPUT3="DisplayPort-2"

# generic
set -exo pipefail
INPUT1=$(xrandr | grep " connected" | awk '{if (NR==1) print $1}')
INPUT2=$(xrandr | grep " connected" | awk '{if (NR==2) print $1}')
INPUT3=$(xrandr | grep " connected" | awk '{if (NR==3) print $1}')

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
