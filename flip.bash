#!/usr/bin/bash

# with both monitors attached, --listactivemonitors | awk FNR > 1:
# 0: +*eDP-1 2160/252x1440/168+0+0 eDP-1 1: +DP-1 3840/600x2160/340+0+0 DP-1

# two arguments: $monitor $rotation
# one argument:  $rotation

monitors=`xrandr --listactivemonitors | awk 'FNR > 1'`
monitors=`echo $monitors | tr ':' '\n' | awk '{print $3}'`
#echo $monitors

if [[ $# -eq 2 ]]
then
	bright=$(brightness | awk '{print $1}')
	
	if [ "$2" == 0 ]
	then
		rotate="normal"
	elif [ "$2" == 1 ]
	then
		rotate="left"
	elif [ "$2" == 2 ]
	then
		rotate="right"
	else
		rotate=$2
	fi
	
	#xrandr --output eDP-1 --rotate $rotate
	#xrandr --output DP-1 --rotate $rotate
	#sleep 0.5
	#xrandr --output eDP1 --brightness $bright

	xrandr --output $1 --rotate $rotate
	if [[ $1 == "eDP-1" || $1 == "eDP1" ]]; then
		xrandr --output $1 --brightness $bright
	fi

elif [[ $# -eq 1 ]]
then
    # rotate all

	bright=$(brightness | awk '{print $1}')
	
	if [ "$1" == 0 ]
	then
		rotate="normal"
	elif [ "$1" == 1 ]
	then
		rotate="left"
	elif [ "$1" == 2 ]
	then
		rotate="right"
	else
		rotate=$1
	fi
	
	#xrandr --output eDP-1 --rotate $rotate
	#xrandr --output DP-1 --rotate $rotate
	#sleep 0.5
	#xrandr --output eDP1 --brightness $bright

	for m in $monitors; do
		xrandr --output $m --rotate $rotate
		if [[ -n $m && $m == "eDP-1" || $m == "eDP1" ]]; then
			xrandr --output $m --brightness $bright
		fi
	done
else
	# echo $(xrandr --verbose | grep $(integrated) | awk '{print $6}')
	# xrandr --output $(external) --rotate $rotate
	for m in $monitors; do
		#dir=`xrandr --verbose | grep "^$m" | grep -o 'normal\|left/1' | head -1`
		dir=`xrandr --verbose | grep "^$m" | grep -E -o '([a-z])\w+ \(' | tr -d '('`
		echo "$dir $m"
	done
fi
