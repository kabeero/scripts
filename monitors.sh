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

MONS=$(xrandr | grep -c " connected")

if [[ $# -eq 1 ]]; then
	select=$(echo "$1" | grep -oE "^[0-9]")
else
	echo
	echo "🖵  Detected displays"
	echo
	displays=$(xrandr | grep " connected" | awk '{print $1}')
	for d in ${displays[@]}; do
		echo "  $d"
	done
	echo
	monitors=("0) Laptop monitor" "1) Single monitor" "2) Dual monitor")
	if [[ $MONS == 3 ]]; then
		monitors=("0) Laptop monitor" "1) Single monitor" "2) Dual monitor" "3) Triple monitor")
	fi
	IFS=$'..'
	select=$(gum choose ${monitors[@]} | grep -oE "^[0-9]")
	if [[ $? -ne 0 ]]; then
		exit
	fi
fi

if [[ $MONS != 1 && $MONS != 2 && $MONS != 3 ]]; then
	echo "🟥 Unsupported number of monitors"
	exit 1
fi

echo "$select"

set -exo pipefail

if [[ $MONS == 1 ]]; then

	INPUT1=$(xrandr | grep " connected" | grep -E "e?DP" | awk '{if (NR==1) print $1}')

	xrandr --output "$INPUT1" --auto

elif [[ $MONS == 2 ]]; then

	INPUT1=$(xrandr | grep " connected" | grep -E "e?DP" | awk '{if (NR==1) print $1}')
	INPUT2=$(xrandr | grep " connected" | grep -E "e?DP" | awk '{if (NR==2) print $1}')

	if [[ $select == "0" ]]; then
		xrandr --output "$INPUT1" --auto
		xrandr --output "$INPUT2" --off
	elif [[ $select == "1" ]]; then
		xrandr --output "$INPUT1" --off
		xrandr --output "$INPUT2" --rotate normal --auto
	elif [[ $select == "2" ]]; then
		xrandr --output "$INPUT1" --auto
		xrandr --output "$INPUT2" --rotate normal --above "$INPUT1" --auto
	fi

elif [[ $MONS == 3 ]]; then

	INPUT1=$(xrandr | grep " connected" | grep -E "e?DP" | awk '{if (NR==1) print $1}')
	INPUT2=$(xrandr | grep " connected" | grep -E "e?DP" | awk '{if (NR==3) print $1}')
	INPUT3=$(xrandr | grep " connected" | grep -E "e?DP" | awk '{if (NR==2) print $1}')

	if [[ $select == "0" ]]; then
		xrandr --output "$INPUT1" --auto
		xrandr --output "$INPUT2" --off
		xrandr --output "$INPUT3" --off
	elif [[ $select == "1" ]]; then
		xrandr --output "$INPUT1" --off
		xrandr --output "$INPUT3" --rotate normal --auto
	elif [[ $select == "2" ]]; then
		xrandr --output "$INPUT1" --off
		xrandr --output "$INPUT2" --rotate left --auto
		xrandr --output "$INPUT3" --rotate right --auto --right-of "$INPUT2"
	elif [[ $select == "3" ]]; then
		xrandr --output "$INPUT1" --auto
		xrandr --output "$INPUT2" --rotate left --auto --right-of "$INPUT1"
		xrandr --output "$INPUT3" --rotate right --auto --right-of "$INPUT2"
	fi
fi

sleep 1

background
