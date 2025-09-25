#!/bin/bash

SCRIPT_PATH="$(realpath "$0")"

lock() {
    # profilePic=$(python3 ~/.config/sway/scripts/profilePicture.py)
    # swaylock --daemonize --indicator-image "$profilePic"

    # hyprlock 2>/dev/null 1>&2 &
    # disown

    swaysettings-locker --daemonize
    sleep 1
}

start() {
    xset s off
    # Killall these prev processes
    killall -9 swayidle
    # Wait until the processes have been shut down
    while pgrep -u $UID -x swayidle >/dev/null; do sleep 1; done

    # Idles after 8min, locks after 10min (2min post idle), suspends after 10min (20min).
    # Lock screen before sleep. If already locked, suspend after 10 mins instead of 20 min
    swayidle -w \
        idlehint 480 \
        timeout 600 "(pidof swaysettings-locker && systemctl suspend) || loginctl lock-session" \
        timeout 1200 "systemctl suspend" \
        before-sleep "$SCRIPT_PATH --lock" \
        lock "$SCRIPT_PATH --lock" 1>&2 &
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
