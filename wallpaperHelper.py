class Wallpaper:
    def __init__(self, startTime, endTime):
        self.startTime = startTime
        self.endTime = endTime

wallpaperNumber = int(input("How many wallpapers? "))
print(str(wallpaperNumber) + " Wallpapers")
transition = int(input("Transition in seconds: "))
wallpaperList = []
for item in range(wallpaperNumber):
    startTime = 0;
    endTime = 0;
    for index in range(2):
         if index == 0:
             startTime = input("Start Time for Wallpaper " + str(index + 1) + ": ")
         else:
             endTime = input("End Time for Wallpaper " + str(index + 1) + ": ")
    wallpaperList.append(Wallpaper(startTime, endTime))

for item in wallpaperList:
    print(str(item.startTime) + " " + str(item.endTime))