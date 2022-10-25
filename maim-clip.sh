#!/usr/bin/env sh
file=$(mktemp ~/screenshot-XXXXX.png)
maim -uso $file; cat $file | xclip -selection clipboard -t image/png
