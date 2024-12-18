#!/bin/bash

lock() {
    # profilePic=$(python3 ~/.config/sway/scripts/profilePicture.py)
    # swaylock --daemonize --indicator-image "$profilePic"
    hyprlock 2>/dev/null 1>&2 &
    disown
}

start() {
    xset s off
    # Killall these prev processes
    killall -9 swayidle
    # Wait until the processes have been shut down
    while pgrep -u $UID -x swayidle >/dev/null; do sleep 1; done

    # Locks after 10min, suspends after 10min (20min). Lock screen before sleep.
    # If already locked, suspend after 10 mins instead of 20 min
    swayidle -w \
        timeout 600 "(pidof hyprlock && systemctl suspend) || loginctl lock-session" \
        timeout 1200 "systemctl suspend" \
        before-sleep "loginctl lock-session" \
        lock "$HOME/.config/sway/scripts/lock.sh --lock" 1>&2 &
    disown
}

case "$1" in
    "--lock")
        lock
        ;;
    *)
        start
        ;;
esac
