#!/bin/bash
function enableFunction(){
    #source
    pacmd list-sources | grep -e 'index:' -e "name:" | grep 'input\|index:'
    read -p "Select Source Index: " source_index
    echo $source_index
    
    #sink
    pacmd list-sinks | grep -e 'index:' -e "name:" | grep 'output\|index:'
    read -p "Select Sink Index: " sink_index
    echo $sink_index
    
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