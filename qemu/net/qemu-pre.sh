#!/usr/bin/env sh

set -x

BR="br0"
TAP="tap0"

sudo ip link add $BR type bridge

sudo ip link set $BR up

IF=$(ip link show up | grep -Eo "(en.*):" | tr -d ":")

sudo ip link set $IF master $BR

sudo dhcpcd $BR

sudo ip tuntap add dev $TAP mode tap group libvirt

# echo 16384 | sudo tee /proc/sys/vm/nr_hugepages

# default_hugepagesz=1G hugepagesz=1G hugepages=32
