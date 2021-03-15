#!/bin/bash

LANGUAGE=en_US

MAX_VOL=100
VOLUME_ICONS=("" "" "")
MUTED_ICON=""
MUTED_COLOR="%{F#6b6b6b}"

function getSink {
    curSink=$(pactl info | grep "Default Sink" | awk '{print $3}')
}

function getVol {
    curVol=$(pactl list sinks | grep -A 15 "$1" | grep "Volume:" | grep -E -v "base volume:" | awk -F : '{print $3; exit}' | grep -o -P '.{0,3}%' | sed 's/.$//' | tr -d ' ')
}

function getIsMuted {
    if [[ "$(pactl list sinks | grep -A 15 "$1" | grep "Mute" | awk '{print $2}')" == "yes" ]]; then
        isMuted=true
    else
        isMuted=false
    fi
}

function output {
    if ! getSink; then
        echo "PulseAudio not running"
        return 1
    fi
    getVol $curSink
    getIsMuted $curSink

    # Fixed volume icons over max volume
    local iconsLen=${#VOLUME_ICONS[@]}
    if [ "$iconsLen" -ne 0 ]; then
        local volSplit=$((MAX_VOL / iconsLen))
        for i in $(seq 1 "$iconsLen"); do
            if [ $((i * volSplit)) -ge "$curVol" ]; then
                volIcon="${VOLUME_ICONS[$((i-1))]}"
                break
            fi
        done
    else
        volIcon=""
    fi

    # Showing the formatted message
    if [[ "$isMuted" = true ]]; then
        prefix="${MUTED_COLOR}${MUTED_ICON}"
    else
        prefix="${volIcon}"
    fi
    echo "${prefix}${curVol}%"
}

function listen {
    local firstRun=0

    # Listen for changes and immediately create new output for the bar.
    # This is faster than having the script on an interval.
    LANG=$LANGUAGE pactl subscribe 2>/dev/null | {
        while true; do
            {
                # If this is the first time just continue and print the current
                # state. Otherwise wait for events. This is to prevent the
                # module being empty until an event occurs.
                if [ $firstRun -eq 0 ]; then
                    firstRun=1
                else
                    read -r event || break
                    # Avoid double events
                    if ! echo "$event" | grep -e "on card" -e "on sink" -e "on server"; then
                        continue
                    fi
                fi
            } &>/dev/null
            output
        done
    }
}


case "$1" in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    togmute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    listen)
        listen
        ;;
    output)
        output
        ;;
esac
