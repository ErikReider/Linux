import subprocess
import time
from typing import List
import math

maxClocks: List[int] = []
while True:
    print("\x1bc" + "/proc/cpuinfo" + ((", Max Clock: " + str(max(maxClocks)) + "MHz") if len(maxClocks) > 0 else ""))
    all_info = str(subprocess.check_output("cat /proc/cpuinfo", shell=True).strip().decode()).splitlines()
    lines: List[str] = []
    for line in all_info:
        if "cpu MHz" in line:
            clock = math.floor(float(line.replace("\t", "").split(": ")[1]))
            index = len(lines)
            if len(maxClocks) <= index:
                maxClocks.append(clock)
            else:
                if maxClocks[index - 1] < clock:
                    maxClocks[index - 1] = clock
            maxClk = str(maxClocks[index - 1])
            lines.append("CPU {0}:\t {1}MHz".format(index, clock) + "\tMaxClock: {0}MHz".format(maxClk))
    print(*lines, sep="\n", end=("\x1b[1A" * (len(lines) - 1)) + "\r", flush=True)
    time.sleep(0.4)
