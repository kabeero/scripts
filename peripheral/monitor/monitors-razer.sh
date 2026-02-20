#!/usr/bin/env bash

set -eo pipefail

export GUM_CHOOSE_CURSOR="• "
export GUM_CHOOSE_CURSOR_FOREGROUND=#22FF88
export GUM_CHOOSE_SELECTED_FOREGROUND=#22FF88
export GUM_CHOOSE_SHOW_HELP=0

INPUTS=("" "" "" "")
MONITORS=("Sharp" "R43" "3223QE" "XXX")
QUIET=""
SCALES=("1.25" "auto" "auto" "auto")
ROTATE=("0" "1" "1" "1")
# layouts for 1/2/3/4 monitors
LAYOUT1=("0x0")
LAYOUT2=("0x0" "0x-2160")
LAYOUT3=("-2160x-840" "0x0" "2160x0")
# LAYOUT3=("auto-left" "auto" "auto-right")
# LAYOUT3=("-3072x1080" "0x0" "4320x0" "2160x0") # eDP @ 1.25
LAYOUT4=("-3072x1080" "0x0" "4320x0" "2160x0") # eDP @ 1.25

for prog in "gum" "jq"; do
    if ! command -v $prog &>/dev/null; then
        echo
        echo >&2 "Please install $prog"
        echo
        exit 1
    fi
done

if [[ ! $XDG_BACKEND =~ "wayland" ]]; then
    echo "Only Wayland supported..."
    exit 1
fi

# Set XDG_RUNTIME_DIR if not set.
# This ensures hyprctl can find the socket file.
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}

# Get the instance signature
HYPR_INST=$(hyprctl instances | grep "instance" | awk '{print $2}' | sed 's/.$//')

# Check if a signature was found
if [ -z "$HYPR_INST" ]; then
    echo "Could not find Hyprland instance signature."
    exit 1
fi

OLD_IFS=$IFS
IFS=$'\n'
displays=($(hyprctl monitors all -j | jq -r '.[].description'))

function bind_displays() {
    idx=0
    for m in "${MONITORS[@]}"; do
        for d in "${displays[@]}"; do
            if echo $d | grep -q $m; then
                # echo "Found $m @ $d"
                INPUTS[$idx]="'desc:${d}'"
                continue
            fi
        done
        echo "INPUTS[${idx}] = ${INPUTS[$idx]}"
        idx=$((idx + 1))
    done
    echo
}

if [[ $# -eq 1 ]]; then
    select=$(echo "$1" | grep -oE "^[0-9]")
else
    echo
    echo "󰍹  Detected displays"
    echo
    for m in ${displays[@]}; do
        echo "  ${GUM_CHOOSE_CURSOR}$m"
    done
    echo

    IFS=$OLD_IFS
    bind_displays

    # INPUT0=${displays[0]}
    # INPUT1=${displays[1]}
    # INPUT2=${displays[2]}
    # INPUT3=${displays[3]}
    # INPUT4=${displays[4]}

    choices=()
    if [[ ${#displays[@]} -ge 1 ]]; then
        choices+=("0) Laptop monitor")
    fi
    if [[ ${#displays[@]} -ge 2 ]]; then
        choices+=("1) External monitor" "2) Dual monitor")
    fi
    if [[ ${#displays[@]} -ge 3 ]]; then
        choices+=("3) Triple monitor")
    fi
    if [[ ${#displays[@]} -ge 4 ]]; then
        choices+=("4) Quad monitor")
    fi
    IFS=$'\n'
    select=$(gum choose ${choices[@]} | grep -oE "^[0-9]")
    if [[ $? -ne 0 ]]; then
        exit
    fi
fi
IFS=$OLD_IFS

echo "Selected: ${select}"

cmd=""
# for disabled in "$INPUT0" "$INPUT1" "$INPUT2" "$INPUT3" "$INPUT4"; do
for disabled in "${INPUTS[@]}"; do
    [[ -n $disabled ]] && cmd+="keyword monitor ${disabled}, disable ; "
done

if [[ $select == "0" ]]; then
    # laptop only
    #                           input    res      pos  scale   rotate
    cmd+="keyword monitor ${INPUTS[0]}, preferred, ${LAYOUT1[0]}, ${SCALES[0]}, transform, ${ROTATE[0]} ; "
elif [[ $select == "1" ]]; then
    # single
    #                           input    res      pos  scale   rotate
    cmd+="keyword monitor ${INPUTS[1]}, preferred, ${LAYOUT1[1]}, ${SCALES[1]}, transform, ${ROTATE[1]}, bitdepth, 10 ; "
elif [[ $select == "2" ]]; then
    if [[ ${#displays[@]} -lt 3 ]]; then
        # dual
        # laptop on, external
        #                           input    res      pos  scale   rotate
        cmd+="keyword monitor ${INPUTS[0]}, preferred, ${LAYOUT2[0]}, ${SCALES[0]}, transform, ${ROTATE[0]} ; "
        cmd+="keyword monitor ${INPUTS[1]}, preferred, ${LAYOUT2[1]}, ${SCALES[1]}, transform, ${ROTATE[1]}, bitdepth, 10 ; "
    else
        # triple+
        # laptop off, dual external
        #                           input    res      pos  scale   rotate
        cmd+="keyword monitor ${INPUTS[1]}, preferred, ${LAYOUT4[1]}, ${SCALES[1]}, transform, ${ROTATE[1]}, bitdepth, 10 ; "
        cmd+="keyword monitor ${INPUTS[3]}, preferred, ${LAYOUT4[3]}, ${SCALES[3]}, transform, ${ROTATE[3]}, bitdepth, 10 ; "
    fi
elif [[ $select == "3" ]]; then
    if [[ ${#displays[@]} -lt 4 ]]; then
        # triple
        # laptop on, dual external
        #                           input    res      pos  scale   rotate
        cmd+="keyword monitor ${INPUTS[0]}, preferred, ${LAYOUT3[0]}, ${SCALES[0]}, transform, ${ROTATE[0]} ; "
        cmd+="keyword monitor ${INPUTS[1]}, preferred, ${LAYOUT3[1]}, ${SCALES[1]}, transform, ${ROTATE[1]}, bitdepth, 10 ; "
        cmd+="keyword monitor ${INPUTS[2]}, preferred, ${LAYOUT3[2]}, ${SCALES[2]}, transform, ${ROTATE[2]}, bitdepth, 10 ; "
    else
        # quad+
        # laptop off, triple external
        #                           input    res      pos  scale   rotate
        cmd+="keyword monitor ${INPUTS[1]}, preferred, ${LAYOUT4[1]}, ${SCALES[1]}, transform, ${ROTATE[1]}, bitdepth, 10 ; "
        cmd+="keyword monitor ${INPUTS[2]}, preferred, ${LAYOUT4[2]}, ${SCALES[2]}, transform, ${ROTATE[2]}, bitdepth, 10 ; "
        cmd+="keyword monitor ${INPUTS[3]}, preferred, ${LAYOUT4[3]}, ${SCALES[3]}, transform, ${ROTATE[3]}, bitdepth, 10 ; "
    fi
elif [[ $select == "4" ]]; then
    # quad
    #                           input    res      pos  scale   rotate
    cmd+="keyword monitor ${INPUTS[0]}, preferred, ${LAYOUT4[0]}, ${SCALES[0]}, transform, ${ROTATE[0]} ; "
    cmd+="keyword monitor ${INPUTS[1]}, preferred, ${LAYOUT4[1]}, ${SCALES[1]}, transform, ${ROTATE[1]}, bitdepth, 10 ; "
    cmd+="keyword monitor ${INPUTS[2]}, preferred, ${LAYOUT4[2]}, ${SCALES[2]}, transform, ${ROTATE[2]}, bitdepth, 10 ; "
    cmd+="keyword monitor ${INPUTS[3]}, preferred, ${LAYOUT4[3]}, ${SCALES[3]}, transform, ${ROTATE[3]}, bitdepth, 10 ; "
fi

set -x
# echo hyprctl ${QUIET} --instance ${HYPR_INST} --batch ${cmd}
hyprctl ${QUIET} --instance ${HYPR_INST} --batch ${cmd}
set +x

sleep 0.5

# background
