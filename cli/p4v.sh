#! /usr/bin/env bash

# Perforce on KDE script

# dark themes (light text on dark background) do not work well with Perforce
# the client will read ~/.config/kdeglobals and use your light colored foreground
# on a light colored background, so it will be difficult to read

QTCONFIG_DEFAULT=~/.config/kdeglobals-zion-green
QTCONFIG_PERFORCE=~/.config/kdeglobals-honeycomb
QTCONFIG_SLINK=~/.config/kdeglobals

# find the latest p4v bin in /opt/p4v
cd /opt/p4v
P4V_REL=`find . -name p4v`
P4V_BIN=`realpath $P4V_REL`
echo $P4V_BIN

if [[ -f "$QTCONFIG_DEFAULT" ]] && [[ -f "$QTCONFIG_PERFORCE" ]] ; 
then
	[[ -f "$QTCONFIG_SLINK" ]] && rm $QTCONFIG_SLINK 
	ln -s $QTCONFIG_PERFORCE $QTCONFIG_SLINK
	$P4V_BIN &
	sleep 2 # p4v takes a while to start up, spawns threads which read kdeglobals
	[[ -f "$QTCONFIG_SLINK" ]] && rm $QTCONFIG_SLINK 
	ln -s $QTCONFIG_DEFAULT $QTCONFIG_SLINK
else
	echo "Could not find $QTCONFIG_SLINK configs"
fi
