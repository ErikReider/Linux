#!/bin/bash
IFS=$'\n'

function showHelp() {
    # Display Help
    echo "Options:"
    echo "  `basename $0`                  Starts the setup"
    echo "  `basename $0` -r, --remove     Unloads the loopback module"
}

function list() {
    if [ "$1" == "input" ]; then
        type="sources"
        search="Source"
    elif [ "$1" == "output" ]; then
        type="sinks"
        search="Sink"
    fi

    activeIndex=`pacmd list-$type | grep -e '* index:' | awk '{print $3}'`
    allDevices=$(pactl list $type | grep -e "$search" -e "Name" | paste -d" " - - | cut -d "#" -f2 | sed -n '/monitor/!p')
    for devices in $allDevices; do
        index=`echo $devices | awk '{print $1}'`
        if (( $activeIndex == $index )); then devices="*$devices"; fi
        echo "  Index: "${devices//"Name: "/} | sed 's/\t/ /; s/alsa_output.//; s/alsa_input.//'
    done
}

function enableFunction() {
    echo "Loopback module:"
    #input
    list "input"
    read -p "Select Source/Input Index: " source_index
    if [ "$source_index" == "" ]; then source_index=$activeIndex; fi
    #output
    list "output"
    read -p "Select Sink/Output Index: " sink_index
    if [ "$sink_index" == "" ]; then sink_index=$activeIndex; fi
    #load module
    pacmd load-module module-loopback latency_msec=1 source=$source_index sink=$sink_index
    echo "Input: $source_index Output: $sink_index"
    echo "Loopback device created"
}

function disableFunction() {
    if [ "`pacmd info | grep loopback`" != "" ]; then
        pacmd unload-module module-loopback
        echo "All loopback devices unleaded"
    else
        echo "No loopback module loaded"
        exit 1
    fi
}

case "$1" in
    "")
       enableFunction;;
    "-r" | "--remove" )
       disableFunction;;
    "-h" | "--help" )
       showHelp;;
    *) showHelp;;
esac

