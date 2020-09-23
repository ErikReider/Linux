#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done



if type "xrandr"; then
    first="false"
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        if [[ $first == "false" ]]; then
            MONITOR=$m polybar top -r &
            first="true"
        else
            MONITOR=$m polybar bottom -r &
        fi
    done
else
    polybar -c ~/.i3/polybar.conf top &
    polybar -c ~/.i3/polybar.conf bottom &
fi

# # Launch bar1 and bar2
# polybar top -r &
# polybar bottom -r;

# echo "Bars launched..."
