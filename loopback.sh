#!/bin/bash
echo "Do you wish to enable the loopback device? [y/n]"
read loop_var
if [[ $loop_var = y ]]
then
	pacmd load-module module-loopback latency_msec=1 source=0 sink=1
else
	pacmd unload-module module-loopback
fi
echo "Done :)"
