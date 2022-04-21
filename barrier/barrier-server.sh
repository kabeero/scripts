#!/usr/bin/env bash
BARRIER_PORT=24800
cfgFile="${HOME}/.config/barrier/barrier.conf"
logFile="${HOME}/.config/barrier/barriers.log"

killall -q barriers || echo "No existing servers found..."
sleep 3

echo "Starting Barrier Server..."
barriers -c ${cfgFile} --disable-crypto -f -d INFO -a 127.0.0.1:${BARRIER_PORT} > ${logFile} 2>&1
