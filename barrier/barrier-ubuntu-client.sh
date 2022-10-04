#!/usr/bin/env sh

BARRIER_LOG="${HOME}/.config/barrier/barrier.log"
BARRIER_HOST="host"
BARRIER_UID="ubuntu"
BARRIER_CLIENT="barrierc"
BARRIER_SERVER="~/code/barrier/barrier-server.sh"
BARRIER_PORT=24800

# Kill any previous barriers ssh tunnels, and local barrierc processes
pgrep -af "ssh -nfL 24800" | awk '{print $1}' | xargs kill
killall -q barrierc || echo "⛔ No Barrier clients running"

# Start desktop barrier server via ssh tunnel, forward the port locally
printf "🔗 Connecting to $BARRIER_HOST...\n"
ssh -nfL ${BARRIER_PORT}:127.0.0.1:${BARRIER_PORT} \
		$BARRIER_HOST -- $BARRIER_SERVER

if [ $? -ne 0 ]; then
    printf "Couldn't establish connection to ${BARRIER_HOST}. Aborting\n"
    exit 1
fi

echo "⏳ Waiting for Server to come up before starting client"
sleep 6

echo "🗘 Starting ${BARRIER_CLIENT}..."
$BARRIER_CLIENT -d DEBUG -n $BARRIER_UID -f 127.0.0.1 > $BARRIER_LOG 2>&1 & ## 2.3

if [ $? -ne 0 ]; then
    printf "Couldn't start ${BARRIER_CLIENT}. Aborting\n"
    exit 1
fi

echo "🌟 Finished"
