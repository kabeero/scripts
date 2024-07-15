#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    zellij ls -s | sort | awk '{printf "\033[32m%15s\033[0m\n", $1}'
else
    zellij
fi
