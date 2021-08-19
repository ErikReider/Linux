#!/bin/sh

kill -STOP $(pgrep GTA5.exe)
sleep 10
kill -CONT $(pgrep GTA5.exe)
