#!/bin/bash

find1="google-chrome-stable"
replace1="google-chrome-stable --enable-features=WebUIDarkMode --force-dark-mode"
sudo sed -i "s|$find1|$replace1|g" /usr/share/applications/google-chrome.desktop
