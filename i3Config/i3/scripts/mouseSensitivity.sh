#!/bin/bash
IFS=$'\n'

function setMouseSettings() {
    xinput --set-prop $id 'libinput Accel Speed' -0.2
}

function setTouchPadSettings() {
    xinput --set-prop $id 'libinput Accel Speed' 1
    xinput --set-prop $id 'libinput Natural Scrolling Enabled' 1
}

whitelist=`cat ~/.config/i3/touchpadWhitelist`

for id in $(xinput list | grep "pointer" | cut -d '=' -f 2 | cut -f 1); do
    name=$(xinput list-props $id | grep "Device '" | awk -F"'" '$0=$2')
    xinput --set-prop $id 'libinput Accel Profile Enabled' 0, 1
    if [[ "${whitelist[@]}" =~ "${name}" ]] || [[ "$name" == *"Touchpad"* ]]; then
        # in Whitelist or name is Touchpad
        setTouchPadSettings
    else
        # Other pointers
        setMouseSettings
    fi
done
