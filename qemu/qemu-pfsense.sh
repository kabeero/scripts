#!/usr/bin/env bash


# Fri Jan 28 04:54:23 PM PST 2022
# graphs:
#   550 MB RAM
#   3% CPU (4 vCPU)
#   1.26 GB HDD


DRIVE="/opt/qemu/drives/pfsense.raw"
NVRAM="/opt/qemu/nvram/pfsense.fd"
ISO1="/opt/qemu/iso/pfsense.iso"
#SO2="/opt/qemu/iso/uefi.iso"

OVMF="/usr/share/ovmf/x64"
OVMF_BIN="OVMF_CODE.secboot.fd"

virsh nodedev-detach pci_0000_03_00_0
virsh nodedev-detach pci_0000_03_00_1
virsh nodedev-detach pci_0000_04_00_0
virsh nodedev-detach pci_0000_04_00_1

qemu-system-x86_64 \
    -enable-kvm                                            `# enable KVM optimizations                    ` \
    -global     ICH9-LPC.disable_s3=1                      `# silently hang without printing error msg    ` \
    -global     driver=cfi.pflash01,property=secure,value=on                                                \
    -drive      file=${OVMF}/${OVMF_BIN},if=pflash,format=raw,unit=0,readonly=on                            \
    -drive      file=${NVRAM},if=pflash,format=raw                                                          \
    -boot       dc                                         `# boot the first vhd                          ` \
    -m          2G                                         `# provide reasonable amount of ram            ` \
    -cpu        host                                       `# emulate the host processor                  ` \
    -smp        4                                          `# num  of cores guest is permitted, all cores ` \
    -machine    type=q35,accel=kvm                         `# modern chipset (PCIe, AHCI), hardware accel ` \
    -device     virtio-scsi-pci,id=scsi0                   `# need virtio-scsi-pci controller             ` \
    -drive      file=${DRIVE},if=none,format=raw,discard=unmap,aio=native,cache=none,id=scsi0               \
    -device     scsi-hd,drive=scsi0,bus=scsi0.0            `# virtio SCSI emulation for (TRIM), (NCQ).    ` \
    -device     virtio-net,netdev=vmnic                    `# networking: pass-thru with virtio support   ` \
    -netdev     user,id=vmnic                                                                               \
    -device     vfio-pci,host=03:00.0,id=net0                                                               \
    -device     vfio-pci,host=03:00.1,id=net1                                                               \
    -device     vfio-pci,host=04:00.0,id=net2                                                               \
    -device     vfio-pci,host=04:00.1,id=net3                                                               \
    -spice      port=5930,disable-ticketing=on                                                              \
    -daemonize                                                                                              \

if [[ $? -eq 0 ]];
then
    spicy -h 127.0.0.1 -p 5930
fi
#    #-snapshot                                                                                               \
#    -drive      file=${ISO1},media=cdrom                   `# set a virtual cd-rom and use iso            ` \
#    -device     intel-hda                                  `# audio controller                            ` \
#    -device     hda-duplex                                 `# simulated sound output thru OS audio system ` \
#    -vga        qxl                                                                                         \
#    -usbdevice  tablet                                     `# send USB mouse pos matching host cursor     ` \
