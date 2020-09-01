#!/bin/bash

function listInputs() {
    number=0
    lastIndex=""
    for var in `pactl list sources short`
    do
        number=$((number+1))
        mod=$((number%7))
        # echo $number $word    $mod
        if [ "$mod" -eq "1" ] || [ "$mod" -eq "2" ];
        then
            numberTwo=$((numberTwo+1))
            modTwo=$((numberTwo%2))
            if [ "${modTwo}" -eq "1" ]
            then
                lastIndex=$var
            else
                if [[ "$var" == *"input"* ]];
                then
                    echo "index ${lastIndex} - ${var}"
                fi
            fi
        fi
    done
}

function listOutputs() {
    number=0
    lastIndex=""
    for var in `pactl list sinks short`
    do
        number=$((number+1))
        mod=$((number%7))
        # echo $number $word    $mod
        if [ "$mod" -eq "1" ] || [ "$mod" -eq "2" ];
        then
            numberTwo=$((numberTwo+1))
            modTwo=$((numberTwo%2))
            if [ "${modTwo}" -eq "1" ]
            then
                lastIndex=$var
            else
                if [[ "$var" == *"output"* ]];
                then
                    echo "index ${lastIndex} - ${var}"
                fi
            fi
        fi
    done
}

function enableFunction(){
    #source
    # pacmd list-sources | grep -e 'index:' -e "name:" | grep 'input\|index:'
    # pactl list sources short
    listInputs
    read -p "Select Source/Input Index: " source_index
    # echo $source_index
    
    #sink
    # pacmd list-sinks | grep -e 'index:' -e "name:" | grep 'output\|index:'
    listOutputs
    read -p "Select Sink/Output Index: " sink_index
    # echo $sink_index
    
    pacmd load-module module-loopback latency_msec=1 source=$source_index sink=$sink_index
}

function disableFunction(){
    pacmd unload-module module-loopback
}

read -p "Do you wish to enable the loopback device? [y/n] " loop_var
if [[ $loop_var = y ]]
then
    enableFunction
else
    disableFunction
fi
echo "Done 😊"