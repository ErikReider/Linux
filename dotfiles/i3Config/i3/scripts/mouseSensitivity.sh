#!/bin/bash
source $(dirname $0)/../settings
IFS=$'\n'

function setMouseSettings() {
    xinput --set-prop $id 'libinput Accel Profile Enabled' $mouseAccereration, 1
    xinput --set-prop $id 'libinput Accel Speed' $mouseSensitivity
    xinput --set-prop $id 'libinput Natural Scrolling Enabled' $mouseNaturalScrolling
}

function setTouchPadSettings() {
    xinput --set-prop $id 'libinput Accel Profile Enabled' $touchpadAccereration, 1
    xinput --set-prop $id 'libinput Accel Speed' $touchpadSensitivity
    xinput --set-prop $id 'libinput Natural Scrolling Enabled' $touchpadNaturalScrolling
    xinput --set-prop $id 'libinput Click Method Enabled' 0, 1
    xinput --set-prop $id 'libinput Middle Emulation Enabled' 1
}

whitelist=`cat ~/.config/i3/touchpadWhitelist`

for id in $(xinput list | grep "pointer" | cut -d '=' -f 2 | cut -f 1); do
    name=$(xinput list-props $id | grep "Device '" | awk -F"'" '$0=$2')
    if [[ "${whitelist[@]}" =~ "${name}" ]] || [[ "$name" == *"Touchpad"* ]]; then
        # in Whitelist or name is Touchpad
        setTouchPadSettings
    else
        # Other pointers
        setMouseSettings
    fi
done
