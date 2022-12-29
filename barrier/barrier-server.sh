#!/usr/bin/env bash
BARRIER_PORT=24800
cfgFileUbuntu="${HOME}/.config/barrier/barrier-ubuntu.conf"
cfgFileWindows="${HOME}/.config/barrier/barrier-windows.conf"
cfgFile=""
logFile="${HOME}/.config/barrier/barriers.log"

ubuntu () {
    echo "💻 Loading Ubuntu config"
    cfgFile=$cfgFileUbuntu
}

windows () {
    echo "  Loading Windows config"
    cfgFile=$cfgFileWindows
}

unknown () {
    echo "Please enter 💻 Ubuntu or   Windows config"
    exit 1
}

if [[ $# -eq 0 ]]; then
    unknown
elif [[ $# -eq 1 ]]; then
    case $1 in
        [uUlL]*)
            ubuntu
            ;;
        [wW]*)
            windows
            ;;
        *)
            unknown
            ;;
    esac
fi

killall -q barriers || echo "No existing servers found..."
sleep 3

echo "🚀 Starting Barrier Server..."
## only binds to eno1
# barriers -c ${cfgFile} --disable-crypto -f -d INFO -a 127.0.0.1:${BARRIER_PORT} > ${logFile} 2>&1

## binds to eno1 + br0
barriers -c ${cfgFile} --disable-crypto -f -d INFO -a 0.0.0.0:${BARRIER_PORT} > ${logFile} 2>&1
