import dbus
import sys
import os
import json
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

DBusGMainLoop(set_as_default=True)
loop = GLib.MainLoop()
bus = dbus.SessionBus()


def printStatus(count: int = 0):
    count = count if count != None else 0
    active: str = "inactive" if count == 0 else "active"
    printDict = {"text": "", "tooltip": "", "alt": active, "class": active}
    print(json.dumps(printDict))


def handleSignal(path, props: dict, r):
    printStatus(props["ClientCount"])


def watchCallback(status: str):
    count = 0
    if status != "":
        gm = bus.get_object("com.feralinteractive.GameMode",
                            "/com/feralinteractive/GameMode")
        iface = dbus.Interface(gm, 'org.freedesktop.DBus.Properties')
        iface.connect_to_signal("PropertiesChanged", handleSignal)
        count = iface.Get("com.feralinteractive.GameMode", "ClientCount")
    printStatus(count=count)


def main():
    bus.watch_name_owner(bus_name="com.feralinteractive.GameMode",
                         callback=watchCallback)
    loop.run()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
    except:
        pass
