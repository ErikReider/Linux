killall -9 kanshi
# Wait until the processes have been shut down
while pgrep -u $UID -x kanshi >/dev/null; do sleep 1; done

kanshi &
