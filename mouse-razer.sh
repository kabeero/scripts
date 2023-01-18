#!/usr/bin/env bash

# set -xe

# MOUSE_STR="Razer Razer Mamba Tournament Edition"
MOUSE_STR="Razer Razer Basilisk Ultimate Dongle"
MOUSE_STR="${MOUSE_STR} [^CSK] .*pointer.*"
MOUSE_PROP="Natural Scrolling Enabled ("

ID=`xinput list | grep -E "$MOUSE_STR" | awk '{print $8}' | sed -e 's/id=//g'`
NATURAL_ID=`xinput list-props $ID | grep "$MOUSE_PROP" | sed -E 's/(.*)\(([0-9]{3})(.*)([0-9]{1})/\2/'`
NATURAL_ON=`xinput list-props $ID | grep "$MOUSE_PROP" | sed -E 's/(.*)\(([0-9]{3})(.*)([0-9]{1})/\4/'`
BUTTON_MAP=`xinput get-button-map $ID | awk '{print $6 $7}'`

# print button map, shows side scroll left/right, etc
button-info () { xinput list --long $ID | grep "Button labels" | sed -e 's/[\t]*Button labels: //g' | sed -e 's/" /\n/g'| sed -e 's/"//g' | sort ; }

# enable / disable / toggle fns
side-on      () { xinput set-button-map $ID 1 2 3 4 5 4 5 8 9 10 11 12 13 14 15 16 17 18 19 20 && echo "Side scrolling enabled"; }
side-off     () { xinput set-button-map $ID 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 && echo "Side scrolling disabled"; }
side-flip    () { [[ $BUTTON_MAP == "67" ]] && side-on || side-off ; }
natural-on   () { xinput set-prop $ID $NATURAL_ID 1 && echo "Natural scrolling enabled" ; }
natural-off  () { xinput set-prop $ID $NATURAL_ID 0 && echo "Natural scrolling disabled"; }
natural-flip () { [ $NATURAL_ON -eq 0 ] && natural-on || natural-off ; }

case $1 in
	
	s|side)
		
		if [ $# -eq 2 ]; then
			if   [[ $2 == "on"  ]] || [[ $2 == "1" ]]; then
				side-on
			elif [[ $2 == "off" ]] || [[ $2 == "0" ]]; then
				side-off
			else
				side-flip
			fi
		else
			[[ $BUTTON_MAP = "45" ]] && echo "Side scrolling enabled" || echo "Side scrolling disabled"
		fi
		;;

	n|natural)

		if [ $# -eq 2 ]; then
			if   [[ $2 == "on"  ]] || [[ $2 == "1" ]]; then
				natural-on
			elif [[ $2 == "off" ]] || [[ $2 == "0" ]]; then
				natural-off
			else
				natural-flip
			fi
		else
			[ $NATURAL_ON -eq 1 ] && echo "Natural scrolling enabled" || echo "Natural scrolling disabled"
		fi
		;;

	b|buttons|button|i|info) button-info ;;
	
	*)	echo "Usage: razer [natural | side | info] [0 | 1 | on | off | toggle]" ;;

esac
