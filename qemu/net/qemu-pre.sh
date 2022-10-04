#!/usr/bin/env sh

set -x

sudo ip link add br0 type bridge

sudo ip link set br0 up

sudo ip link set enp68s0 master br0

sudo dhcpcd br0

sudo ip tuntap add dev tap0 mode tap group libvirt

# echo 16384 | sudo tee /proc/sys/vm/nr_hugepages

# default_hugepagesz=1G hugepagesz=1G hugepages=32
