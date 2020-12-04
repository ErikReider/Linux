#!/bin/bash
if ps -A | grep picom; then
    killall -q picom
fi

# # Wait until the processes have been shut down
while pgrep -u $UID -x picom >/dev/null; do sleep 1; done

picom --config $HOME/.config/picom/picom.conf --experimental-backends --xrender-sync-fence