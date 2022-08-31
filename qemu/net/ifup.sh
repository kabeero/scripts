#!/bin/sh

# set -x

switch=br0

if [[ $# -eq 1 ]]; then
    sudo ip link set $switch up
    sudo dhcpcd $switch
    sleep 0.5s
    sudo ip tuntap add dev $1 mode tap group qemu
    sudo ip link set $1 up
    sleep 0.5s
    sudo ip link set $1 master $switch
    exit 0
else
    echo "Error: no interface specified"
    exit 1
fi
