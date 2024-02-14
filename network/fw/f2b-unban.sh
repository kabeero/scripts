#!/bin/bash
CHAIN=$1
IP=$2

sudo fail2ban-client set ${CHAIN} unbanip ${IP}

