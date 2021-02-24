#!/usr/bin/env bash
WORK_DIR=${HOME}/work
ULTRA_DIR=${HOME}/ultra

if [[ $(mount | grep -i ultra | wc -l) -eq 0 ]]; then
	
	echo "Ultra is not mounted, aborting"

else
	# date && rsync -aq . ~/ultra/ && date && systemctl suspend
	echo "Backing up $WORK_DIR to $ULTRA_DIR"
	
	date
	rsync -haqi --progress $WORK_DIR/* $ULTRA_DIR
	date

fi
