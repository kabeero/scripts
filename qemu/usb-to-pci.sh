#!/usr/bin/env sh

declare -rA COLORS=(
  [RED]=$'\033[0;31m'
  [GREEN]=$'\033[0;32m'
  [BLUE]=$'\033[0;34m'
  [PURPLE]=$'\033[0;35m'
  [CYAN]=$'\033[0;36m'
  [WHITE]=$'\033[0;37m'
  [YELLOW]=$'\033[0;33m'
  [BOLD]=$'\033[1m'
  [OFF]=$'\033[0m'
)

for usb_ctrl in /sys/bus/pci/devices/*/usb*; do 
    pci_path=${usb_ctrl%/*}
    iommu_group=$(readlink $pci_path/iommu_group)
    echo -e "${COLORS[BLUE]}Bus $(cat $usb_ctrl/busnum) --> ${pci_path##*/} (IOMMU group ${iommu_group##*/})${COLORS[OFF]}"
    lsusb -s ${usb_ctrl#*/usb}:
    echo
done
