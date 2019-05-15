#!/usr/bin/bash
if [ -n "$1" ]
then
	bright=$(brightness)
	#integrated=eDP-1
	#external=DP-1
	
	if [ "$1" == 0 ]
	then
		rotate="normal"
	elif [ "$1" == 1 ]
	then
		rotate="left"
	else
		rotate=$1
	fi
	
	xrandr --output eDP-1 --rotate $rotate
	xrandr --output DP-1 --rotate $rotate
	sleep 0.5
	xrandr --output eDP1 --brightness $bright
else
	# echo $(xrandr --verbose | grep $(integrated) | awk '{print $6}')
	# xrandr --output $(external) --rotate $rotate
fi
