#!/bin/bash

if [ -n "$1" ]
then
	NAME=$1
else
	NAME="webinar.ogv"
fi

#ID=xwininfo | grep "Window id:" | awk '{print $4}'
#echo ${ID}

if [ -n "$2" ]
then
	echo "recordmydesktop --windowid $2 --device pulse --freq 44100 -o ${NAME}"
	recordmydesktop --windowid $2 --fps 30 --device pulse --freq 44100 -o ${NAME}
else
	echo "recordmydesktop --device pulse --freq 44100 -o ${NAME}"
	recordmydesktop -x 1 -y 1 --width 1280 --height 720 --fps 30 --device pulse --freq 44100 -o ${NAME}
fi
