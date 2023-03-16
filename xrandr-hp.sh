#!/usr/bin/env bash

set -x

XINPUT="DP-0"
XMODE="2560x1440"
XHZ="165"
xrandr --output DP-0 --mode ${XMODE} --rate ${XHZ} --left-of DP-1
