killall -9 touchegg
# Wait until the processes have been shut down
while pgrep -u $UID -x touchegg >/dev/null; do sleep 1; done
touchegg
