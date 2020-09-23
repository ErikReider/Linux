#!/bin/bash
echo $(getent passwd | grep "$USER" | cut -d":" -f5 | cut -d"," -f1)