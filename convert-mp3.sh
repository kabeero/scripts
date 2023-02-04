#!/usr/bin/env sh

if [[ ! $(command -v ffmpeg) ]]; then
	echo
	echo "🔴 Please install ffmpeg"
	echo
	exit 1
fi

if [[ $# -gt 0 ]]; then
	INFILE="$1"
	echo
	read -p "📻 Continue converting ${INFILE}? " REPLY
	case $REPLY in
		[yY]*)
			echo
			echo "🟢 Processing..."
			echo
			if [[ $# -eq 2 ]]; then
				ffmpeg -i "$1" -c:v copy -c:a libmp3lame -q:a 4 "$2"
			else
				echo "💿 Saving ${1%%.m4a}.mp3"
				echo
				ffmpeg -i "$1" -c:v copy -c:a libmp3lame -q:a 4 "${1%%.m4a}.mp3"
			fi
			;;
		*)
			echo
			echo "❌ Exiting"
			;;
	esac
else
	echo
	echo "🔴 Please provide an input and output filename. (m4a -> mp3 by default)"
	echo
fi
