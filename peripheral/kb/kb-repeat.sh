#!/usr/bin/env sh

if [ $# -eq 0 ]; then
    printf "\nCurrent repeat rate\n\n"
    xset q | grep -E "^(\s)*auto repeat delay"
else 
    if [ $# -eq 2 ]; then
        DELAY=$1
        REPEAT=$2
    else
        DELAY=175
        REPEAT=25
    fi
    printf "\nSetting repeat rate\n\n"
    printf "  auto repeat delay:  %d    repeat rate:  %d\n" $DELAY $REPEAT
    xset r rate $DELAY $REPEAT
fi
