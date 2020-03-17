#!/bin/bash
# random nitrogen bg
# needed for systemd timer
export DISPLAY=:100
BG_PATH=/home/kabeero/pictures/backgrounds
#itrogen --random --set-zoom-fill ${BG_PATH}
nitrogen --random --set-zoom ${BG_PATH} --head=0
nitrogen --random --set-zoom ${BG_PATH} --head=1
#itrogen --random --set-scaled ${BG_PATH}

