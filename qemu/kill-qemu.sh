#kill (pgrep -a qemu | awk '{print $1}')
pkill -e qemu-system
