#!/usr/bin/env zsh

BARRIER_LOG="${HOME}/.config/barrier/barrier.log"
BARRIER_HOST=""
BARRIER_HOST_HOME="home-pc"
BARRIER_HOST_WORK="work-pc"
BARRIER_SERVER=""
BARRIER_SERVER_HOME="~/code/barrier/barrier-server.sh"
BARRIER_SERVER_WORK="~/Code/barrier/barrier-server.sh"
BARRIER_CLIENT="/Applications/Barrier.app/Contents/macOS/barrierc"
BARRIER_PORT=24800

if [[ $# -lt 1 ]]; then
		echo "Please provide a setup to configure: Work or Home"
		exit 1
fi

case $1 in

	[hH]* ) echo "Launching barrier with Home settings..."
			MACHINE="home"
			;;

	[wW]* ) echo "Launching barrier with Work settings..."
			MACHINE="work"
			;;

		* ) echo "$1 not recognized"
			exit 1
			;;
esac

BARRIER_HOST=$(eval echo \$"BARRIER_HOST_${MACHINE:u}")
BARRIER_SERVER=$(eval echo \$"BARRIER_SERVER_${MACHINE:u}")

# Kill any previous barriers ssh tunnels, and local barrierc processes
ps auxwww | egrep -e "[s]sh.*barrier-server" | awk '{print $2}' | xargs kill
killall -q barrierc || echo "⛔ No Barrier clients running"

printf "🔗 Connecting to $BARRIER_HOST...\n"

# # Start desktop barrier server via ssh tunnel, forward the port locally
# ssh -fNL ${BARRIER_PORT}:127.0.0.1:${BARRIER_PORT} \
#          $BARRIER_HOST -- $BARRIER_SERVER

# echo "⏳ Waiting for Server to come up before starting client"
# sleep 6

# Same, but don't start a new server
# ssh -fNL ${BARRIER_PORT}:127.0.0.1:${BARRIER_PORT} \
#          ${BARRIER_HOST} --
# if [ $? -ne 0 ]; then
#     printf "Couldn't establish connection to ${BARRIER_HOST}. Aborting\n"
#     exit 1
# fi

echo "🚀 Starting ${BARRIER_CLIENT}..."
$BARRIER_CLIENT -d DEBUG --disable-crypto -f 127.0.0.1 > $BARRIER_LOG 2>&1 &

if [ $? -ne 0 ]; then
    printf "Couldn't start ${BARRIER_CLIENT}. Aborting\n"
    exit 1
fi

echo "🌟 Finished"
