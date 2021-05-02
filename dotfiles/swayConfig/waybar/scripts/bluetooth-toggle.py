#!/usr/bin/python3.9

import subprocess
import os
import json

result = subprocess.run(["rfkill", "-J"], stdout=subprocess.PIPE)
output = json.loads(result.stdout.decode("utf-8"))[""]

status = list(filter(lambda x: x["type"] == "bluetooth", output))[0]["soft"]

if status == "unblocked":
    # Turn off
    subprocess.run(["bluetoothctl", "power", "off"], stdout=subprocess.PIPE)
    subprocess.run(["rfkill", "block", "bluetooth"], stdout=subprocess.PIPE)
else:
    # Turn on
    subprocess.run(["rfkill", "unblock", "bluetooth"], stdout=subprocess.PIPE)
    subprocess.run(["bluetoothctl", "power", "on"], stdout=subprocess.PIPE)
