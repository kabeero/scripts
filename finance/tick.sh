#!/usr/bin/env bash

progs=(gum csc)
for p in ${progs[@]}; do
	if [ ! $(command -v $p) ]; then
		echo
		echo "🟥 Please install ${p}"
		exit 1
	fi
done

ticker=$(gum input --placeholder="Ticker")
[[ ! $ticker ]] && exit 0

interval=$(gum choose 15m 60m 1h 1d 1wk 1mo)
[[ ! $interval ]] && exit 0

args=(
	"--mode yahoo-fetch"
	"--interval $interval"
	"--ticker $ticker"
)

csc ${args[@]}
