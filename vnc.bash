#!/bin/bash
machine=$1
port=8888

if [[ -n $1 ]]; then
	
	if [ $machine = "m3" ] || [ $machine = "m31" ] 
	then
	   port=8888
	
	elif [ $machine = "m30" ]
	then
		port=7777
	
	elif [ $machine = "poseidon" ]
	then
	   port=9999
	
	# elif [ $machine = "hyper" ]
	# then
	#    port=9999
	
	fi
fi

echo "Connecting to $machine via localhost:$port"
vncviewer -Log *:stderr:30 localhost:$port
