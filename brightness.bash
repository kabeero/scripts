#!/usr/bin/bash

# the hubs switch #s depending on the port
# modeset driver has dashes
# intel   driver does not
INTERNAL0="eDP-1"
EXTERNAL1="DP-1" # left
EXTERNAL2="DP-2" # right (also flipped)

if [ -n "$1" ]
then
	xrandr --output ${INTERNAL0} --brightness $1
else
	echo $(xrandr --verbose | grep Brightness | awk '{print $2}')
fi
