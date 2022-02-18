#!/usr/bin/env bash

DRIVE="/opt/qemu/drives/fedora.qcow2"
NVRAM="/opt/qemu/nvram/fedora.fd"
ISO1="/opt/qemu/iso/fedora.iso"
ISO2="/opt/qemu/iso/uefi.iso"

OVMF="/usr/share/edk2-ovmf"
OVMF_BIN="OVMF_CODE.secboot.fd"

qemu-system-x86_64 \
    -enable-kvm                                            `# enable KVM optimizations                    ` \
    -global     ICH9-LPC.disable_s3=1                      `# silently hang without printing error msg    ` \
    -global     driver=cfi.pflash01,property=secure,value=on                                                \
    -drive      file=${OVMF}/${OVMF_BIN},if=pflash,format=raw,unit=0,readonly=on                            \
    -drive      file=${NVRAM},if=pflash,format=raw                                                          \
    -boot       dc                                         `# boot the first vhd                          ` \
    -m          8G                                         `# provide reasonable amount of ram            ` \
    -cpu        host                                       `# emulate the host processor                  ` \
    -smp        $(nproc)                                   `# num  of cores guest is permitted, all cores ` \
    -machine    type=q35,accel=kvm                         `# modern chipset (PCIe, AHCI), hardware accel ` \
    -device     virtio-scsi-pci,id=scsi0                   `# need virtio-scsi-pci controller             ` \
    -drive      file=${DRIVE},if=none,format=raw,discard=unmap,aio=native,cache=none,id=scsi0               \
    -device     scsi-hd,drive=scsi0,bus=scsi0.0            `# virtio SCSI emulation for (TRIM), (NCQ).    ` \
    -drive      file=${ISO1},media=cdrom                   `# set a virtual cd-rom and use iso            ` \
    -drive      file=${ISO2},media=cdrom                   `# set a virtual cd-rom and use iso            ` \
    -device     virtio-net,netdev=vmnic                    `# networking: pass-thru with virtio support   ` \
    -netdev     user,id=vmnic                                                                               \
    -device     qemu-xhci,id=xhci                          `# host usb pass-thru, with USB 3              ` \
    -device     usb-host,bus=xhci.0,hostdevice=/dev/bus/usb/001/020                                         \
    -usbdevice  tablet                                     `# send USB mouse pos matching host cursor     ` \
    -device     intel-hda                                  `# audio controller                            ` \
    -device     hda-duplex                                 `# simulated sound output thru OS audio system ` \
    -vga        qxl                                                                                         \
    -spice      port=5930,disable-ticketing=on                                                              \
    -daemonize                                                                                              \

if [[ $? -eq 0 ]];
then
    spicy -h 127.0.0.1 -p 5930
fi
    #-snapshot                                                                                               \
    #-device     usb-host,bus=xhci.0,vendorid=0x0909,productid=0x001a                                        \
