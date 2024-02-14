#!/usr/bin/env bash

for cmd in "gum" "brightnessctl"; do
    if [[ ! $(command -v $cmd) ]]; then
        echo
        echo "🔴 Please install $cmd"
        echo
        exit 1
    fi
done


brightness=$(brightnessctl -d intel_backlight g)

header="☀️ Current brightness: $brightness"

brightness=$(\
    seq 1000 1000 18000 | \
    gum filter --header "$header" --placeholder="Brightness..." \
)

if [[ -n $brightness ]]; then
    brightnessctl -d intel_backlight s $brightness | \
        grep -Eo "Current brightness: .*" | \
        sed -e "s/Current/\n☀️ New/"
fi
