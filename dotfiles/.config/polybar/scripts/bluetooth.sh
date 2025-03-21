#!/bin/sh
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
    echo "%{F#66ffffff}%{T9}%{T-}"
else
    if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
    then
        echo "%{T9}%{T-}"
    fi
    echo "%{F#2193ff}%{T9}%{T-}"
fi