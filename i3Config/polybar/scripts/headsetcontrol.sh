#!/bin/bash
charge=`headsetcontrol -b | grep "Battery: " | awk '{ print $2 }'`
if [ "$charge" != "Unavailable" ]; then
    if [[ "$charge" == *Error* ]]; then charge="Charged"; fi
    echo " "$charge
else
    echo
fi
