#!/usr/bin/env bash
lines=10
if [[ $# -eq 1 ]]; then
    lines=$1
fi
kitty +kitten panel --lines $lines sh -c 'htop'
