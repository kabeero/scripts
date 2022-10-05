#!/usr/bin/env sh
IF=$(ip a | grep -Eo "(en.*):" | tr -d ":")

printf "\n\n"
sudo ip route

printf "\n\n"
printf "Removing routes for ${IF}... "

sudo ip route flush dev ${IF} 

printf "Done!\n"

printf "\n\n"
sudo ip route
