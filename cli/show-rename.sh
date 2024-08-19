#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    echo "Please provide some folders to fix"
    exit 1
fi

for f in "$@"; do
    echo "Processing ${f}"
    pushd $f
    find . -mindepth 1 -maxdepth 1 -name "*mkv" | \
        xargs -I {} mv -v {} ../$(basename $f).mkv
    popd
don
