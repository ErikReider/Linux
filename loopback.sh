#!/bin/bash
GLOBIGNORE="*"

function getActiveDevice {
    #sinks or sources
    li=(`pacmd list-$1 | grep -e 'index:'`)
    for((i=0; i<${#li[@]}; i++)); do
        if [[ "${li[i]}" == "*" ]]; then
            activeIndex=${li[${i}+2]}
        fi
    done
}

function list {
    number=0
    lastIndex=""
    audioType="$1"
    if [[ "$1" == "input" ]]; then
        type="sources"
        elif [[ "$1" == "output" ]]; then
        type="sinks"
    fi
    getActiveDevice $type
    for var in `pactl list $type short`; do
        number=$((number+1))
        mod=$((number%7))
        if [ "$mod" == "1" ] || [ "$mod" == "2" ]; then
            numberTwo=$((numberTwo+1))
            modTwo=$((numberTwo%2))
            if [ "${modTwo}" == "1" ]; then
                lastIndex=$var
            else
                if [[ "$var" == *"$audioType"* ]]; then
                    active=""
                    if [ "$activeIndex" == "$lastIndex" ]; then
                        active="[Active]"
                    fi
                    echo "Index ${lastIndex} $active - ${var}"
                fi
            fi
        fi
    done
}

function enableFunction {
    #input
    list "input"
    read -p "Select Source/Input Index: " source_index
    #output
    list "output"
    read -p "Select Sink/Output Index: " sink_index
    #load module
    pacmd load-module module-loopback latency_msec=1 source=$source_index sink=$sink_index
    echo ""
    echo "Loopback device created"
}

function disableFunction {
    pacmd unload-module module-loopback
    echo ""
    echo "All loopback devices unleaded"
}

read -p "Do you wish to enable the loopback device? [Y/n] " loop_var
if [[ $loop_var = y ]]; then
    enableFunction
else
    disableFunction
fi