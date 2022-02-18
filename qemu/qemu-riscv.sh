#!/usr/bin/env bash

DRIVE="/opt/qemu/drives/ubuntu.qcow2"
NVRAM="/opt/qemu/nvram/ubuntu.fd"
ISO1="/opt/qemu/iso/ubuntu.iso"
ISO2="/opt/qemu/iso/uefi.iso"

OVMF="/usr/share/edk2-ovmf"
OVMF_BIN="OVMF_CODE.secboot.fd"

qemu-system-riscv64 \
    -m          8G                                         `# provide reasonable amount of ram            ` \
    -drive      file=${ISO1},media=cdrom                   `# set a virtual cd-rom and use iso            ` \
    -drive      file=${ISO2},media=cdrom                   `# set a virtual cd-rom and use iso            ` \
    -netdev     user,id=vmnic                                                                               \
    #-drive      file=${DRIVE},if=virtio,format=raw                                                          \
