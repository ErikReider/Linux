#!/bin/bash

cleanup() {
    killall -9 caffeinated
}

trap cleanup EXIT

while read line; do
    if [[ "$line" == "RUNNING" ]]; then
        if !(pgrep -x "caffeinated" >/dev/null); then
            caffeinated -d
        fi
    elif [[ "$line" == "NOT RUNNING" ]]; then
        killall -9 caffeinated
    fi
done </dev/stdin
