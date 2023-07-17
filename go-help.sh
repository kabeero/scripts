#!/usr/bin/env bash

set -eou pipefail


if [ ! -x "$(command -v go)" ]; then
    echo "Please install go"
    exit 1
fi

if [ ! -x "$(command -v glow)" ]; then
    echo "Please install glow"
    exit 1
fi

if [ ! -x "$(command -v gum)" ]; then
    echo "Please install gum"
    exit 1
fi


if [ ! -e go.mod ]; then
    echo "Please run in a go module, with a go.mod file"
    exit 1
fi

MOD=""

if [ $# -gt 0 ]; then
    MOD=$1
fi

HELP_MOD=$(
    cat go.mod | \
    grep -E "^require" | \
    sed -e 's/require //; s$ // indirect$$; s$ .*$$' | \
    gum choose
)

if [[ ! -z $MOD ]]; then
    HELP_MOD="$HELP_MOD/$MOD"
fi

HELP_MOD=$(
    gum input \
        --header "🔍 Module to lookup" \
        --value="$HELP_MOD"
)

go doc "$HELP_MOD" | glow -p
