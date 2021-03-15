#!/usr/bin/python3.9
from requests import request
import json
import io
import os

config = io.open(os.environ['HOME'] + "/.config/polybar/owm_config.json", "r")
apiConfig = json.loads(str(config.read()))
config.close()
apiKey, location = apiConfig["API_KEY"], apiConfig["location"]

url = "https://api.openweathermap.org/data/2.5/weather?q=" + \
    location + "&appid=" + apiKey
req = request("GET", url)
result = dict(json.loads(req.text))

temp = str(round(int(result["main"]["temp"]) - 273.15)) + "°C"
icon = result["weather"][0]["icon"]

switcher = {
    "01d": "",
    "01n": "",
    "02d": "",
    "02n": "",
    "03d": "",
    "03n": "",
    "04d": "",
    "04n": "",
    "09d": "",
    "09n": "",
    "10d": "",
    "10n": "",
    "11d": "",
    "11n": "",
    "13d": "",
    "13n": "",
    "50d": "",
    "50n": ""
}

print(temp, switcher.get(icon, ""))
