#!/usr/bin/env bash
STRYKER_DIR=${HOME}/work
ULTRA_DIR=${HOME}/ultra

if [[ $(mount | grep -i ultra | wc -l) -eq 0 ]]; then
	
	echo "Ultra is not mounted, aborting"

else
	# date && rsync -aq . ~/ultra/ && date && systemctl suspend
	echo "Backing up $STRYKER_DIR to $ULTRA_DIR"
	
	date
	rsync -haqi --progress $STRYKER_DIR/* $ULTRA_DIR
	date

fi
