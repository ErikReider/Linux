#!/usr/bin/python3.9

import argparse
import json
import shutil
import os
import gi
import requests

from time import sleep
from filelock import FileLock
from typing import Any, Final
from requests import request

gi.require_version("GLib", "2.0")
from gi.repository import GLib

gi.require_version("Geoclue", "2.0")
from gi.repository import Geoclue

APP_NAME: Final = "org.erikreider.weather-script"
LOCK_PATH: Final = "/tmp/{}.lock".format(APP_NAME)
FILE_PATH: Final = "/tmp/{}.json".format(APP_NAME)
MAX_CACHE_TIME_DIFF: Final = 60 * 10  # 10 minutes
TIMEOUT: Final = MAX_CACHE_TIME_DIFF * 2  # 20 minutes
ERROR_TIMEOUT: Final = 10  # 10 sec


def get_msg(text: str, tooltip: str, alt: str, class_: str):
    printDict = {"text": text, "tooltip": tooltip, "alt": alt, "class": class_}
    return json.dumps(printDict)


def print_error(
    text: str, tooltip: str = "", alt: str = "error", class_: str = "error"
):
    data = get_msg(text, tooltip, alt, class_)
    print(data, flush=True)
    if os.path.exists(FILE_PATH):
        os.remove(FILE_PATH)


def get_coords() -> tuple[float, float]:
    simple = Geoclue.Simple.new_sync(APP_NAME, Geoclue.AccuracyLevel.CITY, None)
    location: Geoclue.Location | None = simple.get_property("location")
    if location == None:
        raise Exception("Could not get location")

    lat: float | None = location.get_property("latitude")
    lon: float | None = location.get_property("longitude")

    if lat == None or lon == None:
        raise Exception("Could not get latitude and longitude")

    return (lat, lon)


def get_weather(skip_cache: bool) -> bool:
    # Print loading json
    data = get_msg("", "", "loading", "loading")
    print(data, flush=True)

    try:
        configPath = os.environ["HOME"] + "/.config/waybar/owm_config.json"
        # Uses the template file and renames it to the correct name
        if not os.path.exists(configPath):
            _ = shutil.copyfile("{path}.template".format(path=configPath), configPath)

        config = open(configPath, "r")
        apiConfig: dict[str, str] = json.loads(str(config.read()))
        config.close()
        api_key = apiConfig["API_KEY"]

        # Get the coordinates
        lat, lon = get_coords()

        url = (
            "https://api.openweathermap.org/data/2.5/weather?"
            + "units=metric&lat={lat}&lon={lon}&appid={api_key}".format(
                lat=lat, lon=lon, api_key=api_key
            )
        )
        req = request("GET", url)
        result: dict[str, Any] = dict(json.loads(req.text))

        if int(result["cod"]) != 200:
            temp = result["message"]
            icon = ""
            tooltip = ""
        else:
            temp = "{}°C".format(int(result["main"]["temp"]))
            icon = result["weather"][0]["icon"]
            tooltip_items = [
                result["name"],
                "Temperature: {}".format(temp),
                "Feels like: {}°C".format(int(result["main"]["feels_like"])),
                "Description: {}".format(result["weather"][0]["description"]),
                "Humidity: {}%".format(result["main"]["humidity"]),
                "Clouds: {}%".format(result["clouds"]["all"]),
            ]
            if "rain" in result:
                tooltip_items += "Rain: {}mm/h".format(result["rain"]["1h"])
            if "snow" in result:
                tooltip_items += "Snow: {}mm/h".format(result["snow"]["1h"])
            tooltip = "\n".join(tooltip_items)

        # Show the loading print for at least 500ms
        sleep(0.5)

        # Print the weather
        data = get_msg(temp, tooltip, icon, icon)
        if not skip_cache:
            with open(FILE_PATH, "w+") as file:
                _ = file.write(data)
                file.close()
        print(data, flush=True)
        return True
    except Exception as error:
        if type(error) == requests.exceptions.ConnectionError:
            print_error("No Connection", "", "no-connection", "no-connection")
        else:
            print_error("Error", str(error))
        return False


def load(skip_cache: bool) -> bool:
    if skip_cache:
        return get_weather(skip_cache)

    with FileLock(LOCK_PATH):
        now = GLib.DateTime.new_now_local()
        if now == None:
            print_error("Could not get time")
            return False

        if os.path.exists(FILE_PATH):
            now_unix = now.to_unix()
            modified_time = int(os.path.getmtime(FILE_PATH))
            # Use cached weather if it's at most 10 mins new
            if now_unix - modified_time < MAX_CACHE_TIME_DIFF:
                try:
                    with open(FILE_PATH, "r") as file:
                        data = json.loads(str(file.read()))
                        if (
                            "text" in data
                            and "tooltip" in data
                            and "alt" in data
                            and "class" in data
                        ):
                            print(json.dumps(data), flush=True)
                            return True
                except Exception:
                    pass
    return get_weather(skip_cache)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    _ = parser.add_argument("-sc", "--skip-cache", action=argparse.BooleanOptionalAction, type=bool)
    args = parser.parse_args()

    SKIP_CACHE: Final[bool] = args.skip_cache
    while True:
        result = load(SKIP_CACHE)
        sleep(TIMEOUT if result else ERROR_TIMEOUT)
