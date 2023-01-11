#!/usr/bin/env sh

# set -xe

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

WLO=$(ip route | grep -Eo "wlo[0-9]+" -m 1)
ENO=$(ip add | grep -Eo "(enp.*):" -m 1 | tr -d ":")
BRIDGED=$(ip add | grep ${ENO} | grep -o "master")

LAN_NET=$(ip route | grep -Eo "^[0-9]+.[0-9.]+{3}/[0-9]+" -m 1)
BR_IF=$(ip add | grep -Eo "[^vir](br[0-9]+)" -m 1 | tr -d ' ')
BR_IP=$(ip add show dev $BR_IF | grep -Eo "inet [0-9]+.[0-9]+.[0-9]+.[0-9]+" -m 1 | awk '{print $2}')
ROUTER=$(ip route | grep -m 1 -E "dev ${BR_IF}" | awk '{print $3}')

if [[ ! -z $BR_IP ]]; then
    printf "Bridge interface not linked, reconnecting...\n"
    sudo dhcpcd $BR_IF && \
        BR_IP=$(ip add show dev $BR_IF | grep -Eo "inet [0-9]+.[0-9]+.[0-9]+.[0-9]+" -m 1 | awk '{print $2}')
fi

if [[ ! -z $WLO ]]; then
    printf "\n\n"
    printf ${COLORS[PURPLE]}
    printf "Detected ${WLO} link, disabling...\n"
    printf ${COLORS[OFF]}
    sudo ip link set ${WLO} down
fi

if [[ -z $BRIDGED ]]; then
    printf "\n\n"
    printf ${COLORS[PURPLE]}
    printf "Detected ${ENO} not bridged, enabling...\n"
    printf ${COLORS[OFF]}
    sudo ip link set ${ENO} master $BR_IF
fi

IF=$(ip link show up | grep -Eo "(en.*):" | tr -d ":")

printf "\n\n"
printf ${COLORS[CYAN]}
ip route
printf ${COLORS[OFF]}

printf "\n\n"

if [[ ! -z $BR_IF ]] && [[ ! -z $BR_IP ]]; then
    printf ${COLORS[PURPLE]}
    printf "Found bridge: ${BR_IF} using ${BR_IP}\n\n"
    printf ${COLORS[OFF]}
else
    printf ${COLORS[RED]}
    printf "Couldn't find a bridge interface with an IP...\n"
    printf ${COLORS[OFF]}
    exit 1
fi

if [[ ! -z $LAN_NET ]]; then
    printf ${COLORS[PURPLE]}
    printf "Found LAN: ${LAN_NET}\n\n"
    printf ${COLORS[OFF]}
else
    printf ${COLORS[RED]}
    printf "Couldn't find a LAN network...\n"
    printf ${COLORS[OFF]}
    exit 1
fi

if [[ ! -z $ROUTER ]]; then
    printf ${COLORS[PURPLE]}
    printf "Found Router: ${ROUTER}\n\n"
    printf ${COLORS[OFF]}
else
    printf ${COLORS[RED]}
    printf "Couldn't find a Router on the network...\n"
    printf ${COLORS[OFF]}
    exit 1
fi

printf "Removing routes for ${IF}... "

sudo ip route flush dev ${IF} 

printf "\n\n"

if [[ ! -z $BR_IF ]]; then
    printf ${COLORS[PURPLE]}
    printf "Adding routes for default...\n"
    printf ${COLORS[OFF]}
    sudo ip route add default via ${ROUTER} dev ${BR_IF} metric 100
fi
    
if [[ ! -z $LAN_NET ]]; then
    printf ${COLORS[PURPLE]}
    printf "Adding routes for LAN...\n"
    printf ${COLORS[OFF]}
    sudo ip route add ${LAN_NET} dev ${BR_IF} proto dhcp scope link src ${BR_IP} metric 200
fi
    
printf "Done!\n"

printf "\n\n"
printf ${COLORS[CYAN]}
ip route
printf ${COLORS[OFF]}
printf "\n"
