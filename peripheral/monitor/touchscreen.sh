#!/usr/bin/bash
ID=`xinput list | grep SYNP1234 | awk '{print $5}' | sed -e 's/id=//g'`
PROP=`xinput list-props ${ID} | grep -i "device enabled (" | awk '{print $3}' | sed -e "s/(//g" | sed -e "s/)://g"`

if [ -n "$1" ]
then
	xinput set-prop ${ID} ${PROP} $1
else
	echo $(xinput list-props ${ID} | grep ${PROP} | awk '{print $4}')
fi
