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

for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d); do 
    echo "IOMMU group $(basename "$iommu_group")"
    for device in $(\ls -1 "$iommu_group"/devices/); do 
        if [[ -e "$iommu_group"/devices/"$device"/reset ]]; then 
            echo -ne "${COLORS[BLUE]}[RESET]"
        else
            echo -n "${COLORS[RED]}[AVOID]"
        fi
        echo -n $'\t'
        lspci -nns "$device"
        echo -e "${COLORS[OFF]}"
    done
done
