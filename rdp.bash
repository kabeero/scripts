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

	if [ $1 == "m3" ]; then
		
		echo "$1: vncviewer $M3_CONN"
		vncviewer $M3_CONN
		exit

	elif [ $1 == "poseidon" ]; then

		echo "$1: vncviewer $POSEIDON_CONN"
		vncviewer $POSEIDON_CONN
		exit

	elif [ $1 == "wellness" ]; then
		CONN=$WELLNESS_CONN
		USER=$WELLNESS_USER
		PASS=$WELLNESS_PASS
	
	elif [ $1 == "bethany" ]; then
		CONN=$BETHANY_CONN
		USER=$BETHANY_USER
		PASS=$BETHANY_PASS
	
	elif [ $1 == "tenderspec" ]; then
		CONN=$TENDER_CONN
		USER=$TENDER_USER
		PASS=$TENDER_PASS
	
	elif [ $1 == "stryker" ]; then
		CONN=$STRYKER_CONN
		USER=$STRYKER_USER
		PASS=$STRYKER_PASS
		WIDTH=3840
		HEIGHT=2100

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
	
	echo "$1: xfreerdp /v:$CONN /u:$USER /p:$PASS /w:$WIDTH /h:$HEIGHT"
	xfreerdp /v:$CONN /u:$USER /p:$PASS /w:$WIDTH /h:$HEIGHT
else
	echo "usage: rdp [m3|poseidon|bethany|wellness|tenderspec|stryker]"
fi;

