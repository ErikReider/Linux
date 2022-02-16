#!/bin/bash
if [[ $1 == "--lock" ]]; then
    profilePic=$(~/.config/sway/scripts/generateRoundProfilePic.sh)
    swaylock --daemonize --effect-compose "96x96;$profilePic"
else
    xset s off
    # Killall these prev processes
    killall -9 swayidle
    # Wait until the processes have been shut down
    while pgrep -u $UID -x swayidle >/dev/null; do sleep 1; done

    # Locks after 10min, suspends after 10min (20min). Lock screen before sleep
    swayidle -w \
        timeout 600 'loginctl lock-session' \
        timeout 1200 'systemctl suspend' \
        before-sleep '~/.config/sway/scripts/lock.sh --lock' \
        lock '~/.config/sway/scripts/lock.sh --lock' &
fi
