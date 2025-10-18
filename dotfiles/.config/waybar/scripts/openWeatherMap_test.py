#!/usr/bin/python3.9

import gi

from typing import Final, Tuple

gi.require_version("Geoclue", "2.0")
from gi.repository import Geoclue


APP_NAME: Final = "org.erikreider.weather-script"


def get_coords() -> Tuple[float, float]:
    simple = Geoclue.Simple.new_sync(APP_NAME, Geoclue.AccuracyLevel.CITY, None)
    location = simple.get_property("location")
    if location == None:
        raise Exception("Could not get location")

    lat = location.get_property("latitude")
    lon = location.get_property("longitude")

    if lat == None or lon == None:
        raise Exception("Could not get latitude and longitude")

    return (lat, lon)


if __name__ == "__main__":
    get_coords()
