#!/bin/sh

rm /tmp/.i3_lock.png
tmpfile=/tmp/.i3_lock.png

scrot "$tmpfile"
convert "$tmpfile" -blur 0x15 "$tmpfile"
i3lock -i "$tmpfile" -t --ignore-empty-password --show-failed-attempts --nofork -p default; sleep 1