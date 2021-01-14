#!/bin/bash

charge=`headsetcontrol -b | grep "Battery: " | awk '{ print $2 }'`
if [ "$charge" != "Unavailable" ]; then
    echo ""$charge
fi
