import pulsectl
import sys
import json


def listen_type(type: str):
    with pulsectl.Pulse(type) as pulse:
        def print_events(ev=None):
            running = False
            if type == "sink":
                li = pulseInfo.sink_list()
                for info in li:
                    if info.state._value == "running":
                        running = True
            else:
                li = pulseInfo.source_output_list()
                running = len(li) > 0

            state = "RUNNING" if running else "NOT RUNNING"
            if "--json" in args:
                names: list[str] = []
                for e in li:
                    name= ""
                    if type == "sink":
                        if e.state._value != "running":
                            continue
                        name = e.name
                    else:
                        if "media.name" in e.proplist:
                            name = e.proplist["media.name"]
                        if "application.name" in e.proplist:
                            name = e.proplist["application.name"]
                    names.append("• " + name)

                state = json.dumps({
                    "text": state,
                    "tooltip": "\n".join(names),
                    "alt": state,
                    "class": state
                })

            sys.stdout.write(state + "\n")
            if "--once" in args:
                exit(0)

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

        if arg == "sink" or arg == "source":
            pulseInfo = pulsectl.Pulse("info")
            listen_type(arg)
        else:
            print("Wrong argument (sink or source)")
            exit(1)
    except KeyboardInterrupt:
        exit(0)
