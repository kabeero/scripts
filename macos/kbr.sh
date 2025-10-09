#!/usr/bin/env bash

# > https://mac-key-repeat.zaymon.dev/

# 120 ms / 75 ms
# defaults write -g InitialKeyRepeat -int 8
# defaults write -g KeyRepeat -int 5

# # 120 ms / 60 ms
# defaults write -g InitialKeyRepeat -int 8
# defaults write -g KeyRepeat -int 4

# # 180 ms / 30 ms
# defaults write -g InitialKeyRepeat -int 12 ;
# defaults write -g KeyRepeat -int 2 ;

# defaults write -g ApplePressAndHoldEnabled -bool false

export BORDER_FOREGROUND=#f137ff

if ! command -v "gum" >/dev/null; then
    echo "Please install gum"
    exit 1
fi

options=(
    "InitialKeyRepeat"
    "KeyRepeat"
    "ApplePressAndHoldEnabled"
)

defaults=(
    "-int 8"
    "-int 5"
    "-bool false"
)
header() {
    txt=$1
    gum style --border="rounded" --margin="0 6" --padding="0 3" "$txt"
}

apply_kbr() {
    header "Original Values"
    read_kbr
    for key in "${!options[@]}"; do
        set -x
        defaults write -g ${options[$key]} ${defaults[$key]}
        set +x
    done
    header "New Values"
    read_kbr
}

read_kbr() {
    table=""
    for key in "${!options[@]}"; do
        val=$(defaults read -g ${options[$key]})
        table+="${options[$key]},${val}\n"
    done
    echo -e "$table" | gum table -p --border="rounded" -c Option,Value
}

case $# in
0)
    header "Current Values"
    read_kbr
    ;;
1)
    apply_kbr
    ;;
esac
