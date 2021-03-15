#!/bin/bash
charge=`headsetcontrol -b 2>&1 | grep "Battery: " | awk '{ print $2 }'`
if [ "$charge" != "Unavailable" ]; then
    if [[ "$charge" == "" ]]; then charge="100%"; fi
    if [[ "$charge" == "Charging" ]]; then 
        charge="<span size='small'></span>"
    fi
    echo "  $charge"
else
    echo
fi
