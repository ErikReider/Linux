#!/bin/bash

killall -9 clipit

while pgrep -u $UID -x clipit >/dev/null; do sleep 1; done

clipit -d 2>/dev/null &
