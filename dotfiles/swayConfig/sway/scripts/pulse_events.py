from enum import Enum
import json
import sys
from typing import List

from pulsectl import Pulse
from pulsectl.pulsectl import PulseEventInfo


def listen_type(type: str):
    with Pulse(type) as pulse:
        class Types(Enum):
            SOURCE = "Source"
            SINK = "Sink"

        def getDeviceStatus(type: Types):
            value = {
                "type": type,
                "state": False,
                "applications": []
            }
            if type == Types.SINK:
                deviceList = pulseInfo.sink_list()
                applicationsList = pulseInfo.sink_input_list()
            elif type == Types.SOURCE:
                deviceList = pulseInfo.source_list()
                applicationsList = pulseInfo.source_output_list()
            else:
                return value

            running = False
            for info in deviceList:
                if info.state._value == "running":
                    running = True
                    break

            names: list[str] = []
            for e in applicationsList:
                if not e.corked:
                    name = ""
                    if "media.name" in e.proplist:
                        name = e.proplist["media.name"]
                    if "application.name" in e.proplist:
                        name = e.proplist["application.name"]
                    names.append("• " + name)

            value["state"] = running
            value["applications"] = names
            return value

        def print_events(ev: PulseEventInfo = None):
            facility = ev.facility._value if ev != None else ""
            if facility != "" and facility != "source" and facility != "sink":
                return

            status = []
            if type == "sink":
                status = [getDeviceStatus(Types.SINK)]
            elif type == "source":
                status = [getDeviceStatus(Types.SOURCE)]
            else:
                status = [
                    getDeviceStatus(Types.SINK),
                    getDeviceStatus(Types.SOURCE)
                ]

            state = list(filter(lambda x: x["state"] == True, status))
            state = "RUNNING" if len(state) > 0 else "NOT RUNNING"

            if "--json" in args:
                def toNames(x):
                    type: Types = x["type"]
                    apps: List[str] = x["applications"]
                    if len(apps) == 0:
                        return ""
                    return type.value + "\n" + "\n".join(apps)
                state = json.dumps({
                    "text": state,
                    "tooltip": "\n".join(list(map(toNames, status))),
                    "alt": state,
                    "class": state
                })

            sys.stdout.write(state + "\n")
            if "--once" in args:
                exit(0)

        pulseInfo = Pulse("info")
        print_events()
        pulse.event_mask_set(type)
        pulse.event_callback_set(print_events)
        pulse.event_listen()


if __name__ == "__main__":
    try:
        args = sys.argv

        if len(args) < 2:
            print("Need extra argument (sink or source)")
            exit(1)

        arg = args[1]

        if arg == "sink" or arg == "source" or arg == "both":
            listen_type(arg if arg != "both" else "all")
        else:
            print("Wrong argument (sink or source or both)")
            exit(1)
    except KeyboardInterrupt:
        exit(0)
