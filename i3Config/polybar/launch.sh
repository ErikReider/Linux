#!/bin/bash
# Seperates every item with \n instead of whitespace
IFS=$'\n'

# Terminate already running bar instances
killall -q polybar

# # Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

wifiDevice=""
ethDevice=""
# Get the ethernet and the wifi module names
for device in `ip link show | awk 'NR % 2 { if ($2 != "lo:" ) print $2}' | cut -d\: -f1`; do
    if [[ "$device" == *"en"* ]]; then
        ethDevice="$device"
    elif [[ "$device" == *"wl"* ]] ; then
        wifiDevice="$device"
    fi
done

if type "xrandr"; then
    for m in $(xrandr --query | grep ' connected'); do
        monitor=$(echo ${m} | cut -f1 -d" ")
        if [[ "$m" == *"primary"* ]]; then
            WIFI=$wifiDevice ETH=$ethDevice MONITOR=$monitor polybar top -r &
        else
            WIFI=$wifiDevice ETH=$ethDevice MONITOR=$monitor polybar bottom -r &
        fi
    done
else
    WIFI=$wifiDevice ETH=$ethDevice polybar -c ~/.i3/polybar.conf top &
    WIFI=$wifiDevice ETH=$ethDevice polybar -c ~/.i3/polybar.conf bottom &
fi