#!/bin/bash

for id in $(xinput list | grep "pointer" | cut -d '=' -f 2 | cut -f 1); do
    xinput --set-prop $id 'libinput Accel Profile Enabled' 0, 1
    if [[ "$(xinput list-props $id | grep Device)" != *"Touchpad"* ]]; then
        xinput --set-prop $id 'libinput Accel Speed' -0.2
    fi
done
