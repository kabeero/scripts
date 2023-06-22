#!/usr/bin/env bash

set -ueo pipefail

init() {

	TRACK_STR="ELAN0686:00 04F3:320D Touchpad"
	TRACK_PROP="Natural Scrolling Enabled ("
	TAP_PROP="Tapping Enabled ("

	xinput_prop_search () {
		props=($(xinput list-props "$1" | grep "$2" | grep -Eo "\([0-9]+\):\s+[0-9]+" | grep -Eo "[0-9]+"))
		prop_id=${props[0]}
		prop_val=${props[1]}
	}

	ID=$(xinput list | grep -E "$TRACK_STR" | grep -Eo "id=[0-9]+" | sed -e "s/id=//g")

	xinput_prop_search $ID "$TRACK_PROP"
	TRACK_ID=$prop_id
	TRACK_ON=$prop_val

	xinput_prop_search $ID "$TAP_PROP"
	TAP_ID=$prop_id
	TAP_ON=$prop_val

}

natural-on   () { xinput set-prop $ID $TRACK_ID 1 && echo "🟢 Natural scrolling enabled" ; }
natural-off  () { xinput set-prop $ID $TRACK_ID 0 && echo "🔴 Natural scrolling disabled"; }
natural-flip () { [[ $TRACK_ON -eq 0 ]] && natural-on || natural-off ; }

tap-on   () { xinput set-prop $ID $TAP_ID 1 && echo "🟢 Tap to click enabled" ; }
tap-off  () { xinput set-prop $ID $TAP_ID 0 && echo "🔴 Tap to click disabled"; }
tap-flip () { [[ $TAP_ON -eq 0 ]] && tap-on || tap-off ; }


info () { echo "Usage: trackpad [natural | tap] [0 | 1 | on | off | toggle]"; }

if [[ $# -eq 0 ]]; then
	info
	exit 1
fi

case $1 in
	
	n|natural)

		init

		if [ $# -eq 2 ]; then
			if   [[ $2 == "on"  ]] || [[ $2 == "1" ]]; then
				natural-on
			elif [[ $2 == "off" ]] || [[ $2 == "0" ]]; then
				natural-off
			else
				natural-flip
			fi
		else
			[[ $TRACK_ON -eq 1 ]] && echo "Natural scrolling enabled" || echo "Natural scrolling disabled"
		fi
		;;

	t|tap)

		init

		if [ $# -eq 2 ]; then
			if   [[ $2 == "on"  ]] || [[ $2 == "1" ]]; then
				tap-on
			elif [[ $2 == "off" ]] || [[ $2 == "0" ]]; then
				tap-off
			else
				tap-flip
			fi
		else
			[[ $TAP_ON -eq 1 ]] && echo "Tap to click enabled" || echo "Tap to click disabled"
		fi
		;;

	*)	info ;;

esac
