#!/usr/bin/env bash

# TODO: macOS does not like xhci, can you pass thru ehci / 2.0?
# TODO: udev permissions for usb devices?

# UPDATE ALL PCIe REFS (`lspci -nnk`) WHEN CHANGING HARDWARE
# ❯ for i in (seq 1 9); lspci -nnk -s $i":" ; end

QDIR="/opt/qemu"

DRIVE="/dev/nvme1n1"
USBDV="Microdia|SINOWEALTH|Lab126"
# some of these are USB 3...
#SBDV="Microdia|SINOWEALTH|Arctis Pro Wireless|Audio-Technica|C-Media Electronics"
#SBDV="blahblahnousb"

#ISO0="/opt/qemu/iso/windows.iso"
#ISO1="${QDIR}/iso/virtio.iso"

NVRAM="${QDIR}/nvram/macos-nvme.fd"
UEFI="${QDIR}/uefi/macos-nvme.fd"

OVMF="/usr/share/edk2-ovmf"
#VMF_BIN="OVMF_CODE.fd"
OVMF_BIN="OVMF_CODE.secboot.fd"

MAC="DE:AD:BE:EF:C1:E0"

drives () {
    media=( $ISO $ISO1 $ISO2 $DRIVE $DRIVE1 $DRIVE2 )
    for d in ${media[@]}; do
        [[ $d ]] && printf '\t'$d'\n'
    done
}

devices_print () {
    lsusb | grep -E "${USBDV}" \
          | awk '{print "\t" $0}' 
}

devices () {
    # USB 3.0
    # -device usb-host,hostdevice=/dev/bus/usb/001/014
    #devices_print | tr -d ':' \
    #             | awk '{print "-device   usb-host,hostdevice=/dev/bus/usb/"$2"/"$4}'

    # USB 2.0
    # -device   usb-host,bus=ehci.0,vendorid=0x0c45,productid=0x652f
    devices_print | tr ':' ' ' \
                  | awk '{print "-device   usb-host,bus=ehci.0,vendorid=0x"$6",productid=0x"$7}'
    #devices_print | tr -d ':' | tr -d "0" \
    #             | awk '{print "-device   usb-host,bus=ehci.0,hostbus="$2",hostaddr="$4}'
}

video_init () {
    if [[ $? -eq 0 ]]; then
        # check if we have video to observe
        if [[ $(echo ${video[@]} | grep -c qxl) -ne 0 ]]; then
            # spice or vnc?
            if [[ $(echo ${video[@]} | grep -c spice) -ne 0 ]]; then
                SPORT=$(echo ${video[@]} | grep -oE "port=[0-9]{4}" | tr -d "port=")
                spicy -h 127.0.0.1 -p ${SPORT}
            else
                if [[ $(echo ${video[@]} | grep -c vnc) -ne 0 ]]; then
                    VPORT=$(echo ${video[@]} | grep -oE "vnc :[0-9]{1,4}" | grep -oE "[0-9]*" | xargs -IX echo "(5900 + X)" | bc)
                    sleep 0.5 ; vncviewer localhost:${VPORT}
                fi
            fi
        fi
    fi
}

printf "Booting with drives: \n" ; drives
echo
printf "Booting with devices:\n" ; devices_print
echo
printf "DEBUG devices:\n" ; devices
echo
read -p "Continue? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy] ]]
then
    echo

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
       # -device     intel-hda                                  `# audio controller                            ` \
       # -device     hda-duplex                                 `# simulated sound output thru OS audio system ` \

    args=(
        -enable-kvm
        -m          32G
        -cpu        host,kvm=off,+invtsc,vmware-cpuid-freq=on
        -smbios     type=2
        -smp        $(nproc)
        -machine    type=q35,accel=kvm
        -boot       order=cd,menu=on
        -global     ICH9-LPC.disable_s3=1
        -global     driver=cfi.pflash01,property=secure,value=on
        -drive      file=${UEFI},if=pflash,format=raw,readonly=off
        -drive      file=${NVRAM},if=pflash,format=raw
        -device     isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
        -device     pcie-root-port,id=pcie.1,bus=pcie.0,addr=1c.0,slot=1,chassis=1,multifunction=on
        -device     vfio-pci,host=01:00.0,id=gpu0,bus=pcie.1
        -device     vfio-pci,host=01:00.1,id=hda0,bus=pcie.1
        -device     vfio-pci,host=03:00.0,id=nvme0
        -netdev     user,id=vmnic
        -device     e1000,netdev=vmnic,mac=${MAC}
        -usbdevice  tablet
        -daemonize
    )

    video=(
        -vga        none
        -vnc        :10
    )
        #-device     ivshmem-plain,memdev=ivshmem,bus=pcie.0
        #-object     memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=128M
        #-vga        none
        #-spice      port=5930,disable-ticketing=on

        #  -device     qemu-xhci,id=xhci
        #  -device     usb-ehci,id=ehci
    usb=(
          -device     usb-ehci,id=ehci
          `devices`
    )

    qemu-system-x86_64 ${args[@]} ${video[@]} ${usb[@]}

    video_init

    #if [[ $? -eq 0 ]];
    #then
    #    #spicy -h 127.0.0.1 -p 5930 & disown spicy;  # spice-gtk
    #    #spicy -h 127.0.0.1 -p 5930
    #    vncviewer localhost:5910
    #fi
else
    read -p "Restore PCIe devices? " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy] ]]
    then
        echo
        #udo virsh nodedev-reattach pci_0000_01_00_0
        #udo virsh nodedev-reattach pci_0000_01_00_1
        sudo virsh nodedev-reattach pci_0000_03_00_0
        printf "\tvfio devices reattached"
    fi
fi
