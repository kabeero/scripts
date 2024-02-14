#!/usr/bin/env bash

set -e

XINPUT="Virtual-1"
XMODE="3792x2084"
XMODEA=($(echo $XMODE | tr "x" " "))
XMODE_TXT=($(cvt ${XMODEA[@]} | tail -1 | awk '/" /{for (i=3;i<NF;i++) printf $i " "}'))

xrandr --newmode ${XMODE} ${XMODE_TXT[@]}
xrandr --addmode ${XINPUT} ${XMODE}
xrandr --output ${XINPUT} --mode ${XMODE}
sleep 1
nitrogen --restore
