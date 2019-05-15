#!/usr/bin/bash

# the hubs switch #s depending on the port
# modeset driver has dashes
# intel   driver does not
INTERNAL0="eDP-1"
EXTERNAL1="DP-2" # left
EXTERNAL2="DP-1" # right (also flipped)

if [ -n "$1" ]
then
	if [ "$1" == 0 ]
	then
		echo "External monitor disabled"
		xrandr --output ${INTERNAL0} --auto
		xrandr --output ${EXTERNAL1} --off
		xrandr --output ${EXTERNAL2} --off
	elif [ "$1" == 1 ]
	then
		echo "Single external"
		xrandr --output ${EXTERNAL1} --mode 3840x2160
		xrandr --output ${EXTERNAL1} --right-of ${INTERNAL0}
		xrandr --output ${INTERNAL0} --auto
	elif [ "$1" == 2 ]
	then
		echo "Double external"
		xrandr --output ${EXTERNAL1} --mode 3840x2160
		xrandr --output ${EXTERNAL2} --mode 3840x2160
		xrandr --output ${EXTERNAL2} --right-of ${EXTERNAL1}
		xrandr --output ${INTERNAL0} --off
	elif [ "$1" == 3 ]
	then
		echo "Double external, flipped"
		xrandr --output ${EXTERNAL1} --mode 3840x2160
		xrandr --output ${EXTERNAL2} --mode 3840x2160
		xrandr --output ${EXTERNAL2} --right-of ${EXTERNAL1}
		flip ${EXTERNAL2} right
		xrandr --output ${EXTERNAL1} --pos 0x0 --output ${EXTERNAL2} --pos 3840x-1250
		xrandr --output ${INTERNAL0} --off
	elif [ "$1" == 4 ]
	then
		echo "Resetting to 4K"
		xrandr --output ${EXTERNAL1} --mode 3840x2160
		xrandr --output ${EXTERNAL2} --mode 3840x2160
	else
		echo "Switching to external monitor"
		xrandr --output ${EXTERNAL1} --mode 3840x2160
		xrandr --output ${EXTERNAL2} --mode 3840x2160
		xrandr --output ${INTERNAL0} --off
	fi

	xrandr --output ${EXTERNAL1} --brightness 1.0
	xrandr --output ${EXTERNAL2} --brightness 1.0
	sleep .5
	background
fi
