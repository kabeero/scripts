WIDTH=2560
HEIGHT=1440

SERVER1=""
SERVER1_CONN=""
SERVER1_USER=""
SERVER1_PASS=""

SERVER2=""
SERVER2_CONN=""
SERVER2_USER=""
SERVER2_PASS=""

SERVER3=""
SERVER3_CONN=""
SERVER3_USER=""
SERVER3_PASS=""

SERVER4=""
SERVER4_CONN=""
SERVER4_USER=""
SERVER4_PASS=""

SERVER5=""
SERVER5_CONN=""
SERVER5_USER=""
SERVER5_PASS=""

if [[ -n $1 ]]; then

	if [ $1 == $SERVER1 ]; then
		
		echo "$1: vncviewer $SERVER1_CONN"
		vncviewer $SERVER1_CONN
		exit

	elif [ $1 == $SERVER2 ]; then

		echo "$1: vncviewer $SERVER2_CONN"
		vncviewer $SERVER2_CONN
		exit

	elif [ $1 == $SERVER3 ]; then
		CONN=$SERVER3_CONN
		USER=$SERVER3_USER
		PASS=$SERVER3_PASS
	
	elif [ $1 == $SERVER4 ]; then
		CONN=$SERVER4_CONN
		USER=$SERVER4_USER
		PASS=$SERVER4_PASS
	
	elif [ $1 == $SERVER5 ]; then
		CONN=$SERVER5_CONN
		USER=$SERVER5_USER
		PASS=$SERVER5_PASS
	
	elif [ $1 == $SERVER6 ]; then
		CONN=$SERVER6_CONN
		USER=$SERVER6_USER
		PASS=$SERVER6_PASS
		WIDTH=3800
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
	xfreerdp +fonts /sound:sys:pulse /multimedia:sys:pulse /gdi:hw /t:'rdp '$1 /v:$CONN /u:$USER /p:$PASS /w:$WIDTH /h:$HEIGHT
else
	echo "usage: rdp [$SERVER1|$SERVER2|$SERVER3|$SERVER4|$SERVER5|$SERVER6]"
fi;

