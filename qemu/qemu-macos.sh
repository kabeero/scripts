#!/usr/bin/env bash

LABEL="CE7C70027C6FE425" # UUID: Windows
DRIVE=$(lsblk -pf | grep ${LABEL} | awk '{print $1}' | grep -o '/dev/nvme[0-9][a-z][0-9]')            # -> /dev/nvme1n1
#RIVE=$(lsblk -pf | grep ${LABEL} | awk '{print $1}' | grep -o '/dev/nvme[0-9][a-z][0-9][a-z][0-9]')  # -> /dev/nvme1n1p4
#ISO0="/opt/qemu/iso/windows.iso"
ISO1="/opt/qemu/iso/virtio.iso"
NVRAM="/opt/qemu/nvram/macos-nvme.fd"
OVMF="/usr/share/edk2-ovmf"
#VMF_BIN="OVMF_CODE.fd"
OVMF_BIN="OVMF_CODE.secboot.fd"

printf "Booting from ${DRIVE}...\n"

read -p "Continue? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy] ]]
then
	virsh nodedev-detach pci_0000_03_00_0
	# rebinds pci device to use vfio-pci kmod
		
	qemu-system-x86_64 \
	    -snapshot                                                                                               \
	    -enable-kvm                                            `# enable KVM optimizations                    ` \
	    -global     ICH9-LPC.disable_s3=1                      `# silently hang without printing error msg    ` \
	    -global     driver=cfi.pflash01,property=secure,value=on                                                \
		-device     isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"         \
	    -drive      file=${OVMF}/${OVMF_BIN},if=pflash,format=raw,unit=0,readonly=on                            \
	    -drive      file=${NVRAM},if=pflash,format=raw                                                          \
	    -boot       order=cd,menu=on                           `# boot the first vhd                          ` \
	    -m          8G                                         `# provide reasonable amount of ram            ` \
	    -cpu        host,+invtsc,vmware-cpuid-freq=on          `# emulate the host processor                  ` \
	    -smp        $(nproc)                                   `# num  of cores guest is permitted, all cores ` \
	    -smbios     type=2                                                                                      \
	    -machine    type=q35,accel=kvm                         `# modern chipset (PCIe, AHCI), hardware accel ` \
	    -usbdevice  tablet                                     `# send USB mouse pos matching host cursor     ` \
	    -device     intel-hda                                  `# audio controller                            ` \
	    -device     hda-duplex                                 `# simulated sound output thru OS audio system ` \
	    -vga        qxl                                                                                         \
	    -spice      port=5930,disable-ticketing=on                                                              \
	    -daemonize                                                                                              \
        -device     vfio-pci,host=03:00.0,id=nvme0             `# requires root, no guest virtio drivers      ` \
	   
	   #-device     virtio-scsi-pci,id=scsi0                   `# need virtio-scsi-pci controller             ` \
	   #-drive      file=${DRIVE},if=none,format=raw,discard=unmap,aio=native,cache=none,id=scsi0               \
	   #-device     scsi-hd,drive=scsi0,bus=scsi0.0            `# virtio SCSI emulation for (TRIM), (NCQ).    ` \
	   
	
	   #-display vnc=127.0.0.1:100                    `# [sdl | none | gtk | vnc]` \
	   #-drive file=${DRIVE},format=raw,media=disk    `# load raw disk` \
	   #-drive      file=${DRIVE},cache=none,if=virtio         `# set a virtual virtio-blk hdd with partition ` \
	   #-drive      file=${ISO0},media=cdrom                   `# set a virtual cd-rom and use iso            ` \
	   
	   
	   #-device scsi-hd,drive=scsi0,bus=scsi0.0       `# ... ` \
	   # -device virtio-serial \
	   # -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
	   # -chardev spicevmc,id=spicechannel0,name=vdagent \
	   # -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
	   # -daemonize                                    `# don't start monitor, we connect using RDP` \
	
	if [[ $? -eq 0 ]];
	then
	    #spicy -h 127.0.0.1 -p 5930 & disown spicy;  # spice-gtk
	    spicy -h 127.0.0.1 -p 5930
	fi
else
	#❯ sudo virsh nodedev-reattach pci_0000_03_00_0
	# Device pci_0000_03_00_0 re-attached
	virsh nodedev-reattach pci_0000_03_00_0

fi
