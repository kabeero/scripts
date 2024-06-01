AUDIO_TYPE="LINE"
# LINE AND MIC ARE SAME?

if [[ $# -eq 0 ]]; then
	
	printf "deleting pipewire links...\n"
	
	pw-link -d alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-0:capture_AUX0 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX0 > /dev/null 2>&1
	pw-link -d alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-0:capture_AUX1 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX1 > /dev/null 2>&1
	pw-link -d alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-1:capture_AUX0 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX0 > /dev/null 2>&1
	pw-link -d alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-1:capture_AUX1 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX1 > /dev/null 2>&1

elif [[ $# -eq 1 ]]; then

	#rintf "creating pipewire links for ${AUDIO_TYPE}...\n"
	printf "creating pipewire links...\n"

	if [[ $AUDIO_TYPE == "LINE" ]] ; then
		# Audio Input: Line In
		pw-link -d alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-0:capture_AUX0 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX0 > /dev/null 2>&1
		pw-link -d alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-0:capture_AUX1 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX1 > /dev/null 2>&1
		pw-link alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-0:capture_AUX0 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX0
		pw-link alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-0:capture_AUX1 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX1
	else
		# Audio Input: Microphone
		pw-link -d alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-1:capture_AUX0 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX0 > /dev/null 2>&1
		pw-link -d alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-1:capture_AUX1 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX1 > /dev/null 2>&1
		pw-link alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-1:capture_AUX0 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX0
		pw-link alsa_input.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-input-1:capture_AUX1 alsa_output.usb-Creative_Technology_USB_Sound_Blaster_HD_00000HhQ-00.pro-output-0:playback_AUX1
	fi;
fi;
