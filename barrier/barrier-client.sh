#!/usr/bin/env sh

BARRIER_UID="linux"
BARRIER_SERVER="host"
BARRIER_LOG="$HOME/.config/barrier/barrier.log"

ssh -NfL 24800:localhost:24800 $BARRIER_SERVER

barrierc -d DEBUG -n ${BARRIER_UID} -f 127.0.0.1 > ${BARRIER_LOG} 2>&1 &
