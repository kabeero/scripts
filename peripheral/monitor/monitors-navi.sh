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

echo "$select"

set -exo pipefail

if [[ $MONS == 1 ]]; then

    INPUT1=$(xrandr | grep " connected" | awk '{if (NR==1) print $1}')

    xrandr --output "$INPUT1" --rotate left --auto

elif [[ $MONS == 2 ]]; then

    INPUT1=$(xrandr | grep " connected" | awk '{if (NR==1) print $1}')
    INPUT2=$(xrandr | grep " connected" | awk '{if (NR==2) print $1}')

    if [[ $select == "0" ]]; then
        #     ╭───────────╮
        #     │           │
        #     │           │
        #     │           │
        #     │     1     │
        #     │           │
        #     │           │
        #     │           │
        #     ╰───────────╯
        # xrandr --output "$INPUT1" --rotate right --auto
        # xrandr --output "$INPUT2" --off
        # ╭─────────────────────╮
        # │                     │
        # │          1          │
        # │                     │
        # ╰─────────────────────╯
        xrandr --output "$INPUT1" --rotate normal --auto
        xrandr --output "$INPUT2" --off
    elif [[ $select == "1" ]]; then
        xrandr --output "$INPUT1" --rotate right --auto
        xrandr --output "$INPUT2" --off
    elif [[ $select == "2" ]]; then
        # ╭───────────╮
        # │           │
        # │           │╭─────────────────────╮
        # │           ││                     │
        # │     2     ││          1          │
        # │           ││                     │
        # │           │╰─────────────────────╯
        # │           │
        # ╰───────────╯
        xrandr --output "$INPUT1" --rotate normal --auto --pos 2160x898
        xrandr --output "$INPUT2" --rotate left --auto --pos 0x0

        # ╭───────────╮╭───────────╮
        # │           ││           │
        # │           ││           │
        # │           ││           │
        # │     2     ││     1     │
        # │           ││           │
        # │           ││           │
        # │           ││           │
        # ╰───────────╯╰───────────╯
        # xrandr --output "$INPUT1" --rotate normal --auto
        # xrandr --output "$INPUT2" --rotate left --auto --left-of "$INPUT1"
    fi

elif [[ $MONS == 3 ]]; then

    INPUT1=$(xrandr | grep " connected" | awk '{if (NR==1) print $1}')
    INPUT2=$(xrandr | grep " connected" | awk '{if (NR==3) print $1}')
    INPUT3=$(xrandr | grep " connected" | awk '{if (NR==2) print $1}')

    if [[ $select == "0" ]]; then
        xrandr --output "$INPUT1" --auto
        xrandr --output "$INPUT2" --off
        xrandr --output "$INPUT3" --off
    elif [[ $select == "1" ]]; then
        xrandr --output "$INPUT1" --off
        xrandr --output "$INPUT3" --rotate normal --auto
    elif [[ $select == "2" ]]; then
        #                        ╭───────────╮╭───────────╮
        #                        │           ││           │
        # ╭─────────────────────╮│           ││           │
        # │ xxxxxxxxxxxxxxxxxxx ││           ││           │
        # │ xxxxxxxxxxxxxxxxxxx ││     2     ││     3     │
        # │ xxxxxxxxxxxxxxxxxxx ││           ││           │
        # ╰─────────────────────╯│           ││           │
        #                        │           ││           │
        #                        ╰───────────╯╰───────────╯
        xrandr --output "$INPUT1" --off
        xrandr --output "$INPUT2" --rotate left --auto
        xrandr --output "$INPUT3" --rotate right --auto --right-of "$INPUT2"
    elif [[ $select == "3" ]]; then
        #                        ╭───────────╮╭───────────╮
        #                        │           ││           │
        # ╭─────────────────────╮│           ││           │
        # │                     ││           ││           │
        # │          1          ││     2     ││     3     │
        # │                     ││           ││           │
        # ╰─────────────────────╯│           ││           │
        #                        │           ││           │
        #                        ╰───────────╯╰───────────╯
        xrandr --output "$INPUT1" --auto
        xrandr --output "$INPUT2" --rotate left --auto --right-of "$INPUT1"
        xrandr --output "$INPUT3" --rotate right --auto --right-of "$INPUT2"
    fi
else
    echo "🟥 Unrecognized number of monitors"
fi

sleep 1

background
