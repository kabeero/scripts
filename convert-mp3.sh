#!/usr/bin/env sh
if [[ $# -eq 2 ]]; then
	ffmpeg -i "$1" -c:v copy -c:a libmp3lame -q:a 4 "$2"
else
	echo "Please provide an input and output filename. (m4a -> mp3 by default)"
fi
