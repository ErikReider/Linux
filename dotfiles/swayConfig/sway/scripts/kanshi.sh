killall -9 kanshi
while pgrep -u $UID -x kanshi >/dev/null; do sleep 1; done
kanshi
