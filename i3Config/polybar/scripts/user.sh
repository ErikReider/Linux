#!/bin/bash
list=(`getent passwd | grep "$USER" | cut -d":" -f5 | cut -d"," -f1`)
echo ${list[0]}