#!/usr/bin/bash
ID=`xinput list | grep -m 1 Mamba | awk '{print $8}' | sed -e 's/id=//g'`
PROP=`xinput list-props ${ID} | grep -m 1 -i 'natural scrolling enabled (' | awk '{print $5}' | sed -e "s/(//g" | sed -e "s/)://g"`

if [ -n "$1" ]
then
	xinput set-prop ${ID} ${PROP} $1
else
	echo $(xinput list-props ${ID} | grep ${PROP} | awk '{print $6}')
fi
