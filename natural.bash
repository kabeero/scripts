#!/usr/bin/bash
ID=`xinput list | grep Touchpad | awk '{print $6}' | sed -e 's/id=//g'`
PROP=`xinput list-props ${ID} | grep -i "natural scrolling enabled (" | awk '{print $5}' | sed -e "s/(//g" | sed -e "s/)://g"`

if [ -n "$1" ]
then
	xinput set-prop ${ID} ${PROP} $1
else
	echo $(xinput list-props ${ID} | grep ${PROP} | awk '{print $6}')
fi
