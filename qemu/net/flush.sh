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

IF=$(ip a | grep -Eo "(en.*):" | tr -d ":")

printf "\n\n"
printf ${COLORS[CYAN]}
ip route
printf ${COLORS[OFF]}

LAN_NET=$(ip route | grep -Eo "^[0-9]+.[0-9.]+{3}/[0-9]+" -m 1)
BR_IF=$(ip route | grep -E "dev br[0-9]+" -m 1 | grep -Eo "br[0-9]+")
BR_IP=$(ip route | grep -E ${BR_IF} | grep -E ${LAN_NET} -m 1 | awk '{print $9}')
ROUTER=$(ip route | grep -m 1 -E "dev ${BR_IF}" | awk '{print $3}')

printf "\n\n"

if [[ ! -z $BR_IF ]] && [[ ! -z $BR_IP ]]; then
    printf ${COLORS[PURPLE]}
    printf "Found bridge: ${BR_IF} using ${BR_IP}\n\n"
    printf ${COLORS[OFF]}
else
    printf ${COLORS[RED]}
    printf "Couldn't find a bridge interface...\n"
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
