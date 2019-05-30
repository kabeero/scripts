WIDTH=2560
HEIGHT=1440

M3_CONN="127.0.0.1:7777"
POSEIDON_CONN="127.0.0.1:8888"

BETHANY_CONN=""
BETHANY_USER=""
BETHANY_PASS=""

WELLNESS_CONN=""
WELLNESS_USER=""
WELLNESS_PASS=""

TENDER_CONN=""
TENDER_USER=""
TENDER_PASS=""

STRYKER_CONN=""
STRYKER_USER=""
STRYKER_PASS=""

if [[ -n $1 ]]; then

	if [ $1 == "1" ]; then
		
		echo "$1: vncviewer $M3_CONN"
		vncviewer $M3_CONN
		exit

	elif [ $1 == "2" ]; then

		echo "$1: vncviewer $POSEIDON_CONN"
		vncviewer $POSEIDON_CONN
		exit

	elif [ $1 == "3" ]; then
		CONN=$WELLNESS_CONN
		USER=$WELLNESS_USER
		PASS=$WELLNESS_PASS
	
	elif [ $1 == "4" ]; then
		CONN=$BETHANY_CONN
		USER=$BETHANY_USER
		PASS=$BETHANY_PASS
	
	elif [ $1 == "5" ]; then
		CONN=$TENDER_CONN
		USER=$TENDER_USER
		PASS=$TENDER_PASS
	
	elif [ $1 == "6" ]; then
		CONN=$STRYKER_CONN
		USER=$STRYKER_USER
		PASS=$STRYKER_PASS
		WIDTH=3840
		HEIGHT=2070

	if [[ -n $2 ]]; then
		WIDTH=$2
	fi;
	if [[ -n $3 ]]; then
		HEIGHT=$3
	fi;
	
	else
		echo "$1 not recognized"
		exit
	fi;
	
	echo "$1: xfreerdp /v:$CONN /u:$USER /p:******** /w:$WIDTH /h:$HEIGHT"
	xfreerdp /sound:sys:pulse /multimedia:sys:pulse /gdi:hw /t:'rdp '$1 /v:$CONN /u:$USER /p:$PASS /w:$WIDTH /h:$HEIGHT
else
	echo "usage: rdp [1|2|3|4|5|6]"
fi;

