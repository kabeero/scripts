#!/usr/bin/env sh

BARRIER_LOG="${HOME}/.config/barrier/barrier.log"
BARRIER_HOST="host"
BARRIER_UID="linux"
BARRIER_CLIENT="barrierc"
BARRIER_PORT=24800

pid_brc=$(pgrep -f "barrierc")
if [ -n $pid_brc ]; then
    echo "🔴 Terminating existing barrier client"
    kill -9 $pid_brc
fi

pid_ssh=$(pgrep -f "ssh -nNfL")
if [ -n $pid_ssh ]; then
    echo "🔴 Terminating existing ssh tunnel"
    kill -9 $pid_ssh
fi

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
