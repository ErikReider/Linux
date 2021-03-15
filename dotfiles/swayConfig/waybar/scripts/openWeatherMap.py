#!/usr/bin/python3.9
from requests import request
import json
import io
import os

try:
    configPath = os.environ['HOME'] + "/.config/waybar/owm_config.json"
    # Uses the template file and renames it to the correct name
    if not os.path.exists(configPath):
        os.system("cp " + configPath+".template " + configPath)

    config = io.open(configPath, "r")
    apiConfig = json.loads(str(config.read()))
    config.close()
    apiKey, location = apiConfig["API_KEY"], apiConfig["location"]

    url = "https://api.openweathermap.org/data/2.5/weather?q=" + \
        location + "&appid=" + apiKey
    req = request("GET", url)
    result = dict(json.loads(req.text))

    if int(result["cod"]) >= 400:
        temp = result["message"]
        icon = ""
    else:
        temp = str(int(result["main"]["temp"] - 273.15)) + "°C"
        icon = result["weather"][0]["icon"]

    printDict = {"text": temp, "tooltip": "", "alt": icon, "class": icon}

    print(json.dumps(printDict))
except:
    exit(1)
