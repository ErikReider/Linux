import subprocess
output = subprocess.Popen("autorandr --config", shell=True, stdout=subprocess.PIPE)
output = filter(lambda x: "off" not in x and x, output.stdout.read().decode().replace("\n", " ").split("output "))
[print(("primary-" if "primary" in x.split() else "") + x.split()[0]) for x in output]