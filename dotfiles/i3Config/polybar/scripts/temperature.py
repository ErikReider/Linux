#!/usr/bin/python3.9
import json
import subprocess
import os

configPath = os.environ['HOME'] + "/.config/polybar/temp_devices.json"
# Uses the template file and renames it to the correct name
if not os.path.exists(configPath):
    os.system("cp " + configPath+".template " + configPath)
configRead = open(configPath, "r")
config = dict(json.loads(str(configRead.read())))
configRead.close()

cmd = "/usr/bin/sensors -j 2>/dev/null"
allInfo = json.loads(str(subprocess.check_output(cmd, shell=True).decode()))

data = []
for device in config:
    if device == "DEVICENAME":
        continue
    options: dict = config[device]
    for op in options:
        output = allInfo[device][op][options[op]["name"]]
        prefix, suffix = options[op]["prefix"], options[op]["suffix"]
        data.append(str(prefix) + str(int(output)) + str(suffix))

print("  ".join(data))
