#!/usr/bin/env zsh

BARRIER_LOG="${HOME}/.config/barrier/barrier.log"
BARRIER_HOST="host"
BARRIER_CLIENT="/Applications/Barrier.app/Contents/macOS/barrierc"
BARRIER_SERVER="~/code/barrier/barrier-server.sh"
BARRIER_PORT=24800

# Kill any previous barriers ssh tunnels, and local barrierc processes
ps auxwww | egrep -e "[s]sh.*barrier-server" | awk '{print $2}' | xargs kill
killall -q barrierc || echo "No Barrier clients running...";

# Start desktop barrier server via ssh tunnel, forward the port locally
ssh -nfL ${BARRIER_PORT}:127.0.0.1:${BARRIER_PORT} \
		$BARRIER_HOST -- $BARRIER_SERVER

echo "Waiting for Server to come up before starting client"
sleep 6

echo "Starting Client"
$BARRIER_CLIENT -d DEBUG --disable-crypto -f 127.0.0.1 > $BARRIER_LOG 2>&1 &

echo "Finished"
