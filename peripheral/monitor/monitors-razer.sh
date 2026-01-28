#!/usr/bin/env bash

set -eo pipefail

export GUM_CHOOSE_CURSOR="• "
export GUM_CHOOSE_CURSOR_FOREGROUND=#22FF88
export GUM_CHOOSE_SELECTED_FOREGROUND=#22FF88
export GUM_CHOOSE_SHOW_HELP=0

# env | sort >debug-env-01.txt
# SHLVL=3

QUIET=""
SCALES=("1.25" "auto" "auto")
ROTATE=("0" "0" "1")
LAYOUT1=("0x0")
LAYOUT2=("0x0" "0x-2160")
LAYOUT3=("-6000x0" "-2160x-840" "0x0")

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

displays=($(IFS=$'\n' hyprctl monitors all -j | jq -r '.[].name'))

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
    choices=()
    if [[ ${#displays[@]} -ge 1 ]]; then
        INPUT0=${displays[0]}
        choices+=("0) Laptop monitor")
    fi
    if [[ ${#displays[@]} -ge 2 ]]; then
        INPUT1=${displays[1]}
        choices+=("1) External monitor" "2) Dual monitor")
    fi
    if [[ ${#displays[@]} -ge 3 ]]; then
        INPUT2=${displays[2]}
        choices+=("3) Triple monitor")
    fi
    IFS=$'\n'
    select=$(gum choose ${choices[@]} | grep -oE "^[0-9]")
    if [[ $? -ne 0 ]]; then
        exit
    fi
fi

sleep 3

if [[ $select == "0" ]]; then
    # laptop only
    #                           input    res      pos  scale   rotate
    cmd=""
    cmd+="keyword monitor ${INPUT0}, preferred, ${LAYOUT1[0]}, ${SCALES[0]}, transform, ${ROTATE[0]}, bitdepth, 10;"
    cmd+="keyword monitor ${INPUT1}, disable;"
    set -x
    hyprctl ${QUIET} --instance ${HYPR_INST} --batch ${cmd}
    set +x
elif [[ $select == "1" ]]; then
    # single
    #                           input    res      pos  scale   rotate
    cmd=""
    cmd+="keyword monitor ${INPUT0}, disable;"
    cmd+="keyword monitor ${INPUT1}, preferred, ${LAYOUT1[0]}, ${SCALES[1]}, transform, ${ROTATE[0]}, bitdepth, 10;"
    set -x
    hyprctl ${QUIET} --instance ${HYPR_INST} --batch ${cmd}
    set +x
elif [[ $select == "2" ]]; then
    # dual
    #                           input    res      pos  scale   rotate
    cmd=""
    cmd+="keyword monitor ${INPUT0}, preferred, ${LAYOUT2[0]}, ${SCALES[0]}, transform, ${ROTATE[0]}, bitdepth, 10;"
    cmd+="keyword monitor ${INPUT1}, preferred, ${LAYOUT2[1]}, ${SCALES[1]}, transform, ${ROTATE[1]}, bitdepth, 10;"
    set -x
    hyprctl ${QUIET} --instance ${HYPR_INST} --batch ${cmd}
    set +x
elif [[ $select == "3" ]]; then
    # triple
    #                           input    res      pos  scale   rotate
    cmd=""
    cmd+="keyword monitor ${INPUT0}, preferred, ${LAYOUT3[0]}, ${SCALES[0]}, transform, ${ROTATE[0]}, bitdepth, 10;"
    cmd+="keyword monitor ${INPUT1}, preferred, ${LAYOUT3[1]}, ${SCALES[1]}, transform, ${ROTATE[1]}, bitdepth, 10;"
    cmd+="keyword monitor ${INPUT2}, preferred, ${LAYOUT3[2]}, ${SCALES[2]}, transform, ${ROTATE[2]}, bitdepth, 10;"
    set -x
    hyprctl ${QUIET} --instance ${HYPR_INST} --batch ${cmd}
    set +x
fi

hyprctl reload

sleep 1

# background
