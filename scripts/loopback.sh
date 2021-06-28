#!/bin/bash
IFS=$'\n'

function showHelp() {
    # Display Help
    echo "Options:"
    echo "  $(basename $0)                  Starts the setup"
    echo "  $(basename $0) -r, --remove     Unloads the loopback module"
}

function disableFunction() {
    pactl unload-module module-loopback
}

function getActiveIndex() {
    defaultDevice=$(pactl info | grep "Default Source" | awk '{print $3}')
    allDevices=$(pactl list sources short | awk '{ print $1 " " $2 }')
    for device in $allDevices; do
        if [[ $(echo $device | awk '{print $2}') == $defaultDevice ]]; then
            activeIndex=$(echo $device | awk '{print $1}')
            break
        fi
    done
}

function list() {
    getActiveIndex
    allDevices=$(pactl list sources short | awk '{print $1 " " $2}' |
        sed -n '/monitor/!p')
    devices=()
    for device in $allDevices; do
        local index=$(echo $device | awk '{print $1}')
        device=$(echo $device | awk '{print $2}')
        if (($activeIndex == $index)); then
            device="* $device"
        else
            device="  $device"
        fi
        devices+=(${device} " ")
    done

    source=$(whiptail --menu "Select Input/Source" 0 0 0 \
        ${devices[@]} 3>&1 1>&2 2>&3 |
        awk -F " " '{ if ($2) {print $2} else {print $1} }')
}

function enableFunction() {
    list
    if [ "$source" == "" ]; then exit 1; fi
    disableFunction
    pactl load-module module-loopback latency_msec=1 sink=@DEFAULT@ source=$source
}

case "$1" in
"")
    enableFunction
    ;;
"-r" | "--remove")
    disableFunction
    ;;
"-h" | "--help")
    showHelp
    ;;
*) showHelp ;;
esac
