#!/usr/bin/env bash

DRIVE="/opt/qemu/drives/windows.qcow2"
NVRAM="/opt/qemu/nvram/windows.fd"
ISO1="/opt/qemu/iso/windows.iso"
#SO1="/opt/qemu/iso/uefi.iso"
ISO2="/opt/qemu/iso/virtio.iso"

OVMF="/usr/share/edk2-ovmf"
#VMF_BIN="OVMF_CODE.fd"
OVMF_BIN="OVMF_CODE.secboot.fd"

read -p "Continue? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy] ]]
then
	qemu-system-x86_64 \
	    -enable-kvm                                            `# enable KVM optimizations                    ` \
	    -global     ICH9-LPC.disable_s3=1                      `# silently hang without printing error msg    ` \
	    -global     driver=cfi.pflash01,property=secure,value=on                                                \
	    -drive      file=${OVMF}/${OVMF_BIN},if=pflash,format=raw,unit=0,readonly=on                            \
	    -drive      file=${NVRAM},if=pflash,format=raw                                                          \
	    -boot       dc                                         `# boot order: windows drive letters           ` \
	    -m          8G                                         `# provide reasonable amount of ram            ` \
	    -cpu        host                                       `# emulate the host processor                  ` \
	    -smp        $(nproc)                                   `# num  of cores guest is permitted, all cores ` \
	    -machine    type=q35,accel=kvm                         `# modern chipset (PCIe, AHCI), hardware accel ` \
	    -device     virtio-scsi-pci,id=scsi0                   `# need virtio-scsi-pci controller             ` \
	    -drive      file=${DRIVE},if=none,format=raw,discard=unmap,aio=native,cache=none,id=scsi0               \
	    -device     scsi-hd,drive=scsi0,bus=scsi0.0            `# virtio SCSI emulation for (TRIM), (NCQ).    ` \
	    -device     virtio-net,netdev=vmnic                    `# networking: pass-thru with virtio support   ` \
	    -netdev     user,id=vmnic                                                                               \
	    -usbdevice  tablet                                     `# send USB mouse pos matching host cursor     ` \
	    -device     intel-hda                                  `# audio controller                            ` \
	    -device     hda-duplex                                 `# simulated sound output thru OS audio system ` \
	    -device     virtio-serial-pci                          `# clipboard sync: spice extensions            ` \
	    -chardev    spicevmc,id=vdagent,name=vdagent                                                            \
	    -device     virtserialport,chardev=vdagent,name=com.redhat.spice.0                                      \
	    -device     ivshmem-plain,memdev=ivshmem,bus=pcie.0    `# enable shm for lookingglass buffer copy     ` \
	    -object     memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=64M            \
	    -vga        qxl                                                                                         \
	    -spice      port=5930,disable-ticketing=on                                                              \
	    -daemonize                                                                                              \
	
	if [[ $? -eq 0 ]];
	then
	    spicy -h 127.0.0.1 -p 5930
	fi
	    #-snapshot                                                                                               \
	    #-smbios     type=11,value=4e32566d-8e9e-4f52-81d3-5bb9715f9727:MIIDazCCAlOgAwIBAgIUYhrSAK2YA27jh+kc8EnRJDYYJbIwDQYJKoZIhvcNAQELBQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoMGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yMTEyMzExMDA1MThaFw0yMjAxMzAxMDA1MThaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC29YkYhxKs1C3SNlRyMAxBViS/IFIRX8NqE+MbHO1BYqyiO2/FhabauVqJZSdi5I2t4pcbxbxdRdzhB8626cTXBhTM5FRXCG8mrtZ0d6hIGwn3i9FoBZAqEBxTmSkoz3IOjLMBjgQDHPKm5HVvzGoNRnkY/cJoCAUNNLmuMBGzcsDKMPs1wt+/Y80TAE2E8QKCgufqKt9/wKphP9LiBJ12tvNArNmhd7EGMzh70HWwe8t9w4vpV2TBmdZSUD5vdac1nENcsJ8saySv79nrgnyUq2miZejc7eBJ5ae2wlVbzUyIpYV7Vxeqirh1DDiKTX4wPBeodEcJfmXlHluel4S1AgMBAAGjUzBRMB0GA1UdDgQWBBQ52KWubuPEi+92WakO2+rHz/PvUjAfBgNVHSMEGDAWgBQ52KWubuPEi+92WakO2+rHz/PvUjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAJuDtWyrhm+VlGbazbCSiHNEA/yMoh9mGBbmtPx6Qqfzb1XT1bY3lAaLfkaoXXrvQwmswSCm88w8OUvi2HjDJj6I6735aQ41t+/gyIvAmPQ4YmN7AEeb4MqfLIcneTFEczTq7BQHbiOEY0AYHJ5UJ8z4pta7CjYTi13rFhF+Edpw7X2nVfxJuDR33wGJ9ixTEtIYXopKbqkoaBi0BSE8tnc91WI+8kZcu4wHfRP8WjedyLGKloFpczlGhaTyDeCA/Be4Jk6RkA3xZT0YdBld6Kk156iY4/lXZaEzy/HB2BEEwnIOFqHQvY+uCG/SmlNE43ZEf1dsgk3J6bmxpLOdjr \
	    #-drive      file=${ISO1},media=cdrom                   `# set a virtual cd-rom and use iso            ` \
	    #-drive      file=${ISO2},media=cdrom                   `# windows installer: cant find drives         ` \
fi
