#!/bin/bash
if [[ "$1" == "--lock" ]]; then
    profilePic=$(~/.config/sway/scripts/generateRoundProfilePic.sh)
    swaylock \
        --daemonize \
        --fade-in 0.2 \
        --image ~/.cache/wallpaper \
        --ignore-empty-password \
        --indicator-caps-lock \
        --indicator \
        --indicator-radius 60 \
        --indicator-thickness 5 \
        --effect-blur 10x10 \
        --effect-vignette 0.5:0.5 \
        --effect-compose "192x192;$profilePic" \
        --line-color 00000000 \
        --line-clear-color 00000000 \
        --line-caps-lock-color 00000000 \
        --line-ver-color 00000000 \
        --line-wrong-color 00000000 \
        --ring-color 00000033 \
        --ring-caps-lock-color 5500A3FF \
        --ring-wrong-color FF0000FF \
        --separator-color 00000000 \
        --text-color 00000000 \
        --text-clear-color 00000000 \
        --text-clear-color 00000000 \
        --text-wrong-color 00000000 \
        --text-ver-color 00000000 \
        --text-caps-lock-color 00000000 \
        --inside-color 00000000 \
        --inside-clear-color 00000000 \
        --inside-caps-lock-color 00000000 \
        --inside-ver-color 00000000 \
        --inside-wrong-color 00000000
else
    xset s off
    # Killall these prev processes
    killall -9 xss-lock
    killall -9 swayidle
    # Wait until the processes have been shut down
    while pgrep -u $UID -x xss-lock >/dev/null; do sleep 1; done
    while pgrep -u $UID -x swayidle >/dev/null; do sleep 1; done

    xss-lock --transfer-sleep-lock -- ~/.config/sway/scripts/lock.sh --lock &

    # Locks after 300s, displays off after +300s. Lock screen before sleep
    swayidle -w \
        timeout 600 'loginctl lock-session' \
        timeout 1200 'systemctl suspend' \
        before-sleep 'loginctl lock-session'
    # resume 'swaymsg "output * dpms on"' \
fi
