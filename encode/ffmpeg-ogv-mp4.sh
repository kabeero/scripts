#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    echo "Please provide an input file to process"
    exit 1;
fi

in_file="$1"
out_file="${in_file%.*ogv}.mp4"

echo
if [[ ! -f ${in_file} ]]; then
    echo "❓ Couldn't find input file ${in_file}"
    exit 1
fi

echo "💾 Input  file: ${in_file}"
echo
echo "💿 Output file: ${out_file}"
echo

read -p "Continue? "

options=(
    -i ${in_file}
    -c:v libx264
    -preset veryslow
    -crf 30
    -q:v 10
    ${out_file}
)

if [[ $REPLY =~ ^[Yy] ]]; then
    echo
    echo "🎥 Running ffmpeg!"
    echo
    ffmpeg ${options[@]}
fi
echo
