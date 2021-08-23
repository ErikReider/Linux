from os import environ
from dbus import Interface, SystemBus

home= environ["HOME"]
image = home + "/.config/sway/assets/profile_pic_default.svg"

try:
    username= environ["USER"]

    bus = SystemBus()

    obj = bus.get_object("org.freedesktop.Accounts", "/org/freedesktop/Accounts");
    userPath = Interface(obj, dbus_interface="org.freedesktop.Accounts").FindUserByName(username)

    obj = bus.get_object("org.freedesktop.Accounts", userPath);
    interface= Interface(obj, dbus_interface="org.freedesktop.DBus.Properties")
    image = interface.Get("org.freedesktop.Accounts.User", "IconFile")
except:
    pass
print(image)
