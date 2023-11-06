#!/usr/bin/env bash

# toggle kitty's theme to light or dark

set -euo pipefail

cmds=("kitty" "gum")
for c in ${cmds[@]}; do
    if [[ ! $(command -v "$c") ]]; then
        echo "Please install $c"
        exit 1
    fi
done

if [[ $# -eq 0 ]]; then
    mode=$(gum choose "Light" "Dark")
else
    mode=$1
fi

case $mode in
    Li*|l*)
            echo "Using light mode"
            kitty +kitten themes "GitHub Light"
            ;;
    Da*|d*)
            echo "Using dark mode"
            kitty +kitten themes "noirblaze"
            ;;
    *)
            echo "Unknown theme"
            ;;
esac
