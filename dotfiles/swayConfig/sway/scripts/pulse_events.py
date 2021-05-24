import pulsectl
import sys
import json


pulseInfo = pulsectl.Pulse("info")


def listen_type(type: str):
    with pulsectl.Pulse(type) as pulse:
        def print_events(ev):
            if type == "sink":
                li = pulseInfo.sink_list()
            else:
                li = pulseInfo.source_list()
            running = False
            for info in li:
                if info.state._value == "running":
                    running = True
            string = "RUNNING" if running else "NOT RUNNING"
            if len(args) > 2 and args[2] == "--json":
                jsonOutput = {"text": string, "tooltip": string,
                              "alt": string, "class": "USINGMIC"}
                string = json.dumps(jsonOutput)
            sys.stdout.write(string + "\n")

        print_events(None)

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

        if arg == "sink" or arg == "source":
            listen_type(arg)
        else:
            print("Wrong argument (sink or source)")
            exit(1)
    except KeyboardInterrupt:
        exit(0)
