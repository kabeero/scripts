This package contains the tianocore edk2 UEFI firmware for 64-bit x86
virtual machines. The firmware is located under
	/usr/share/edk2-ovmf/OVMF_CODE.fd
	/usr/share/edk2-ovmf/OVMF_VARS.fd
	/usr/share/edk2-ovmf/OVMF_CODE.secboot.fd

If USE=binary is enabled, we also install an OVMF variables file (coming from
fedora) that contains secureboot default keys

	/usr/share/edk2-ovmf/OVMF_VARS.secboot.fd

If you have compiled this package by hand, you need to either populate all
necessary EFI variables by hand by booting
	/usr/share/edk2-ovmf/UefiShell.(iso|img)
or creating OVMF_VARS.secboot.fd by hand:
	https://github.com/puiterwijk/qemu-ovmf-secureboot

The firmware does not support csm (due to no free csm implementation
available). If you need a firmware with csm support you have to download
one for yourself. Firmware blobs are commonly labeled
	OVMF{,_CODE,_VARS}-with-csm.fd

In order to use the firmware you can run qemu the following way

	$ qemu-system-x86_64 		-drive file=/usr/share/edk2-ovmf/OVMF.fd,if=pflash,format=raw,unit=0,readonly=on 		...
