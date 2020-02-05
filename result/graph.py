import numpy as np
import matplotlib.pyplot as plt
import sys
import re

path = "./seed3"
#path = "./seed6"
#files = [path + "/cga.txt"]
files = [path + "/simplega.txt", path + "/cga.txt", path + "/ecga.txt"]


data_dict = {}

for fil in files:

    time = []
    i = 0
    f = open(fil)
    data = f.read()
    f.close()
    lines = data.split("\n")

    data_dict[fil] = []
    for line in lines:
        i += 1
        if i == 100:
            break
        time.append(i)
        if not line:
            break
        data_dict[fil].append(float(line))


for k, v in data_dict.items():
    #plt.clf()
    plt.scatter(time, v, s=10, alpha=0.5)
    plt.ylabel("Highest Fitness")
    plt.xlabel("Generation")
    plt.grid(True)
    plt.savefig(path+"/graph.png")

        

