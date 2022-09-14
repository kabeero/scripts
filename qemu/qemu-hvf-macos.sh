#!/usr/bin/env bash

DRIVE="drives/machine.qcow2"
NVRAM="nvram/machine.fd"
ISO1="iso/machine.iso"

args=(
	-cpu        host
	-M          accel=hvf
    -machine    type=q35
    -global     ICH9-LPC.disable_s3=1
    -m          4G
    -smp        4
    -device     virtio-scsi-pci,id=scsi0
    -drive      file=${DRIVE},if=none,format=qcow2,discard=unmap,cache=none,id=scsi0
    -device     scsi-hd,drive=scsi0,bus=scsi0.0
    -drive      file=${ISO1},media=cdrom
    -device     virtio-net,netdev=vmnic
    -netdev     user,id=vmnic,hostfwd=tcp::2222-:22
    -device     VGA,vga_mem_mb=128
    -usbdevice  tablet
    -vnc        :10
    -daemonize
)
    #-cpu        host
    # works, slow
    #-drive      file=${DRIVE},if=virtio,format=raw
    # sad
    #-vga        qxl

qemu-system-x86_64 ${args[@]}

if [[ $? -eq 0 ]];
then
    vncviewer localhost:5910
fi
