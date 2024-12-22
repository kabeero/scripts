#!/usr/bin/env bash

# Gracefully remove Thunderbolt devices via sys class pci

for prog in "boltctl" "gum"; do
    if (! command -v $prog >/dev/null); then
        echo "Please install $prog"
        exit 1
    fi
done

trap abort INT

function abort() {
    set +x
    echo "Aborting"
    exit 1
}

export GUM_CHOOSE_SHOW_HELP=0

function ScanThunderbolt() {
    model="elgato"
    uuid=""
    syspath=""

    readarray -t -d '\n' devices < <(boltctl list | grep -iA9 $model)
    echo "${devices[@]}"

    for device in "${devices[@]}"; do
        uuid=$(echo "$device" | grep -i uuid)
        if [[ $uuid ]]; then
            uuid=$(echo "$uuid" | tr -s ' ' | awk '{print $3}')
        fi
    done

    echo
    if [[ -z "$uuid" ]]; then
        echo "Couldn't find a connected $model device"
    else
        echo "Found $model device @ $uuid"
        echo
        boltctl info "$uuid"
        syspath=$(boltctl info "$uuid" | grep -i syspath | tr -s ' ' | awk '{print $4}' | sed -e "s#\(.*\)/\(domain.*/.*\)#\1#")
        if [ -n "$syspath" ]; then
            echo
            echo "Found syspath:"
            echo
            echo "$syspath"
        fi
    fi
    echo
}

ScanThunderbolt

options=("Connect")
if [ "$syspath" ]; then
    options=("Disconnect")
fi

op=$(gum choose --header "󱐋 Operation:" "${options[@]}")
case $op in
Connect)
    echo "Connecting device"
    set -x
    echo 1 | sudo tee /sys/bus/pci/rescan >/dev/null
    set +x
    sleep 2
    ScanThunderbolt
    ;;
Disconnect)
    echo "Disconnecting device"
    set -x
    echo 1 | sudo tee "$syspath"/remove
    set +x
    sleep 2
    ScanThunderbolt
    ;;
esac
