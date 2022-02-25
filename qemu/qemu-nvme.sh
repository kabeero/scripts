#!/usr/bin/env bash

# UPDATE ALL PCIe REFS (`lspci -nnk`) WHEN CHANGING HARDWARE
# ❯ for i in (seq 1 9); lspci -nnk -s $i":" ; end

QDIR="/opt/qemu"

# need to unbind vfio-pci to see device
#LABEL="CE7C70027C6FE425" # UUID: Windows
#DRIVE=$(lsblk -pf | grep ${LABEL} | awk '{print $1}' | grep -o '/dev/nvme[0-9][a-z][0-9]')            # -> /dev/nvme1n1
##RIVE=$(lsblk -pf | grep ${LABEL} | awk '{print $1}' | grep -o '/dev/nvme[0-9][a-z][0-9][a-z][0-9]')  # -> /dev/nvme1n1p4
DRIVE="/dev/nvme1n1"

#SO0="${QDIR}/iso/windows.iso"
#SO1="${QDIR}/iso/virtio.iso"

NVRAM="${QDIR}/nvram/windows-nvme.fd"
UEFI="${QDIR}/uefi/win-nvme.fd"

#VMF_BIN="OVMF_CODE.secboot.fd"
IGVT_ROM="${QDIR}/iso/vbios_gvt_uefi.rom"

GPU_ROM="${QDIR}/gpu/rx580.rom"

NET_SH="${QDIR}/net/ifup.sh"
MAC="DE:AD:BE:EF:C1:E0"

printf "Booting with drives:\n"
media=( $ISO $ISO1 $ISO2 $DRIVE $DRIVE1 $DRIVE2 )
for d in ${media[@]}; do
	[[ $d ]] && printf '\t'$d'\n'
done

read -p "Continue? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy] ]]
then
    echo
    # rebinds pci device to use vfio-pci kmod

    # i915
    #udo virsh nodedev-detach pci_0000_00_02_0
        #-device     vfio-pci,host=00:02.0,id=igpu0,addr=0x2,romfile=${IGVT_ROM}
    
    #sudo virsh nodedev-detach pci_0000_00_01_0
    #lspci -nnk -s 00:01.0 | grep -E "Subsystem|Kernel driver in use"
    #echo
   
   	# RX 580: VGA
    sudo virsh nodedev-detach pci_0000_01_00_0
    lspci -nnk -s 01:00.0 | grep -E "Subsystem|Kernel driver in use"
    echo
    # RX 580: HDMI Audio
    sudo virsh nodedev-detach pci_0000_01_00_1
    lspci -nnk -s 01:00.1 | grep -E "Subsystem|Kernel driver in use"
    echo
    # Samsung NVMe
    sudo virsh nodedev-detach pci_0000_03_00_0
    lspci -nnk -s 03:00.0 | grep -E "Subsystem|Kernel driver in use"
    echo
    
    echo "vfio devices detached"
    echo

        #-cpu        host,kvm=off,hv_vendor_id=null

	args=(
        -enable-kvm
        -m          32G
        -cpu        host,kvm=off,+invtsc,vmware-cpuid-freq=on
        -smp        $(nproc)
        -machine    type=q35,accel=kvm
        -boot       order=cd,menu=on
        -global     ICH9-LPC.disable_s3=1
        -global     driver=cfi.pflash01,property=secure,value=on
        -drive      file=${UEFI},if=pflash,format=raw
        -drive      file=${NVRAM},if=pflash,format=raw
        -device     isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
        -device		pcie-root-port,id=pcie.1,bus=pcie.0,addr=1c.0,slot=1,chassis=1,multifunction=on
        -device     vfio-pci,host=01:00.0,id=gpu0,bus=pcie.1
        -device     vfio-pci,host=01:00.1,id=hda0,bus=pcie.1
        -device     vfio-pci,host=03:00.0,id=nvme0
        -netdev     user,id=vmnic
        -device     e1000,netdev=vmnic,mac=${MAC}
        -usbdevice  tablet
        -device     ivshmem-plain,memdev=ivshmem,bus=pcie.1
        -object     memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=128M
        -spice      port=5930,disable-ticketing=on
        -vga        none
        -daemonize
    )
        #-device     ivshmem-plain,memdev=ivshmem,bus=pcie.0
        #-object     memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=128M
        #-vga        none
        #-spice      port=5930,disable-ticketing=on

    usb=(
          -device     qemu-xhci,id=xhci
    	 `lsusb | grep -E "Microdia|SINOWEALTH|Audio-Technica|C-Media Electronics" | tr -d ':' | \
    	  awk '{print "-device   usb-host,hostdevice=/dev/bus/usb/"$2"/"$4}'`
    )

    qemu-system-x86_64 ${args[@]} ${usb[@]}

    #if [[ $? -eq 0 ]];
    #then
    #    spicy -h 127.0.0.1 -p 5930
    #fi
else
	read -p "Restore devices? " -n 1 -r
	echo
	
	if [[ $REPLY =~ ^[Yy] ]]
	then
    	echo
    	sudo virsh nodedev-reattach pci_0000_01_00_0
    	sudo virsh nodedev-reattach pci_0000_01_00_1
    	sudo virsh nodedev-reattach pci_0000_03_00_0
    	echo "vfio devices reattached"
    fi
fi

#IOMMU Group 1:
#	00:01.0 PCI bridge [0604]: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) [8086:1901] (rev 0a)
#	01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] [1002:67df] (rev e7)
#	01:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1002:aaf0]

#   https://wiki.gentoo.org/wiki/GPU_passthrough_with_libvirt_qemu_kvm#QEMU
#   > a dedicate root port other than pcie.0 is required by amd gpu for windows driver

