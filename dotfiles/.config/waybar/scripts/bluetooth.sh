#!/bin/sh
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
    echo "<span foreground='#928374'>  </span>"
else
    if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]; then
        echo "  "
    fi
    echo "<span foreground='#2193ff'>  </span>"
fi
