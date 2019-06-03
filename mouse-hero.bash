#!/usr/bin/env bash

# logitech hero side scroll settings

ID=`xinput list | grep -E "G502 HERO Gaming Mouse \W" | awk '{print $8}' | sed -e 's/id=//g'`

function info
{
	#input list --long $ID | grep "Button labels" | sed -e 's/\s\sButton labels: //g' | sed -e 's/" /\n/g' | sed -e 's/"//g' | sort
	xinput list --long $ID | grep "Button labels" | sed -e 's/[\t]*Button labels: //g' | sed -e 's/" /\n/g' | sed -e 's/"//g' | sort
}

function disabled
{
	xinput set-button-map $ID 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
	echo "side scroll disabled"
}

function enabled
{
	xinput set-button-map $ID 1 2 3 4 5 4 5 8 9 10 11 12 13 14 15 16 17 18 19 20
	echo "side scroll enabled"
}

case $1 in

	"off")
		disabled
		;;

	"disable")
		disabled
		;;

	"on")
		enabled
		;;

	"enable")
		enabled
		;;
	
	*)
		info
		;;

esac
