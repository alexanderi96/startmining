#!/bin/bash
#
# A simple launcher script for managing unMineable mining sessions with CPU, GPU or both in a tmux session

# Pool info
PROTOCOL="stratum+tcp://"
DOMAIN="unmineable.com"
PORT="3333"

# CPU Miner configs
CPU_ALGO="rx"
CPU_URL=$CPU_ALGO.$DOMAIN:$PORT

# GPU Miner configs
GPU_ALGO="ethash"
GPU_URL=$PROTOCOL$GPU_ALGO.$DOMAIN:$PORT

# Referral codes
MY="k29t-na3a"
FRIEND="80jz-deiw"
REFERRAL="luz1-zely"

# User configs
COIN="SFM"
MYADDR="YOURADDRESS"
WORKER=$HOSTNAME
REF=$REFERRAL

USER=$COIN:$MYADDR.$WORKER#$REF
PASS="x"

# Mining command

# Running xmrig with sudo in order to be able to use huge pages
CPU="sudo xmrig -o $CPU_URL -a $CPU_ALGO -k -u $USER -p $PASS --randomx-1gb-pages"
GPU="teamredminer -o $GPU_URL -a $GPU_ALGO -u $USER -p $PASS"

# Tmux configs
USECPU=false
USEGPU=false
SESSION="Miner"

startTmux() {
	tmux kill-session -t $SESSION
	tmux new-session -d -s $SESSION

	if $USECPU && $USEGPU; then
		tmux split-window -v -t $SESSION:0.0
		tmux send-keys -t $SESSION:0.0 "$CPU" Enter
		tmux send-keys -t $SESSION:0.1 "$GPU" Enter
	elif $USECPU; then
		tmux send-keys -t $SESSION:0.0 "$CPU" Enter

	elif $USEGPU; then
		tmux send-keys -t $SESSION:0.0 "$GPU" Enter
	fi

	tmux a -t $SESSION:0.0
}

while getopts ":cg" option
do
	case $option in
		c) #CPU
			USECPU=true;;
		g) #GPU
			USEGPU=true;;
		\?) #Invalid arg
			echo "Invalid options"
			exit;;
	esac
done

if $USECPU || $USEGPU; then
	startTmux
else
	echo "No option selected, exiting."
fi

