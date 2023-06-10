#!/usr/bin/env sh

BARRIER_LOG="${HOME}/.config/barrier/barrier.log"
BARRIER_HOST="host"
BARRIER_UID="linux"
BARRIER_CLIENT="barrierc"
BARRIER_PORT=24800

# Kill any previous barriers ssh tunnels, and local barrierc processes
killall -q barrierc || echo "⛔ No Barrier clients running"

# Start desktop barrier server via ssh tunnel, forward the port locally
printf "🔗 Connecting to $BARRIER_HOST...\n"
ssh -nNfL ${BARRIER_PORT}:127.0.0.1:${BARRIER_PORT} $BARRIER_HOST

echo "🧶 Starting ${BARRIER_CLIENT}..."
$BARRIER_CLIENT \
	-d DEBUG \
	-n $BARRIER_UID \
	--disable-crypto \
	-f 127.0.0.1 > $BARRIER_LOG 2>&1 &

if [ $? -ne 0 ]; then
    printf "Couldn't start ${BARRIER_CLIENT}. Aborting\n"
    exit 1
fi

echo "🌟 Finished"
