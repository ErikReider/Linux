#!/bin/bash
if [[ "$1" == "--lock" ]]; then
    swaylock \
        --daemonize \
        --ignore-empty-password \
        --show-failed-attempts \
        --screenshots \
        --clock \
        --indicator \
        --indicator-radius 100 \
        --indicator-thickness 10 \
        --effect-blur 10x10 \
        --effect-vignette 0.5:0.5 \
        --line-color 00000000 \
        --separator-color 00000000 \
        --fade-in 0.2
else
    # Killall these prev processes
    killall -9 swayidle
    # Wait until the processes have been shut down
    while pgrep -u $UID -x swayidle >/dev/null; do sleep 1; done

    # Locks after 300s, displays off after +300s. Lock screen before sleep
    swayidle -w \
        timeout 600 '~/.config/sway/scripts/lock.sh --lock' \
        timeout 610 'swaymsg "output * dpms off"' \
             resume 'swaymsg "output * dpms on"' \
        before-sleep '~/.config/sway/scripts/lock.sh --lock'
fi
