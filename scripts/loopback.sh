#!/bin/bash
IFS=$'\n'

function showHelp() {
    # Display Help
    echo "Options:"
    echo "  $(basename $0)                  Starts the setup"
    echo "  $(basename $0) -r, --remove     Unloads the loopback module"
}

function getActiveIndex() {
    defaultDevice=$(pactl info | grep "Default $search" | awk '{print $3}')
    allDevices=$(pactl list $type short | awk '{ print $1 " " $2 }')
    for device in $allDevices; do
        if [[ $(echo $device | awk '{print $2}') == $defaultDevice ]]; then
            activeIndex=$(echo $device | awk '{print $1}')
            break
        fi
    done
}

function list() {
    if [ "$1" == "input" ]; then
        type="sources"
        search="Source"
    elif [ "$1" == "output" ]; then
        type="sinks"
        search="Sink"
    fi

    getActiveIndex
    allDevices=$(pactl list $type short | awk '{print $1 " " $2}' | sed -n '/monitor/!p')
    for device in $allDevices; do
        index=$(echo $device | awk '{print $1}')
        if (($activeIndex == $index)); then device="*$device"; fi
        echo "  Index: "${device//"Name: "/} | sed 's/\t/ /; s/alsa_output.//; s/alsa_input.//'
    done
}

function enableFunction() {
    echo "Loopback module:"
    #input
    list "input"
    read -p "Select Input/Source Index: " source_index
    if [ "$source_index" == "" ]; then source_index=$activeIndex; fi
    #output
    list "output"
    read -p "Select Output/Sink Index: " sink_index
    if [ "$sink_index" == "" ]; then sink_index=$activeIndex; fi
    #load module
    pactl load-module module-loopback latency_msec=1 source=$source_index sink=$sink_index
    echo "Input: $source_index Output: $sink_index"
    echo "Loopback device created"
}

function disableFunction() {
    pactl unload-module module-loopback
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
