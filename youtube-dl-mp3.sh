#!/usr/bin/env bash
if [ "$#" -eq 1 ]; then
	youtube-dl -x --audio-format mp3 --audio-quality 0 $1
else
	echo "Usage: youtube-dl-mp3 filename"
fi
