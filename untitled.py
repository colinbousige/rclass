import numpy as np
import matplotlib.pyplot as plt
data = np.loadtxt("/Users/colin/Travail/Enseignements/R/Data/rubis_01.txt")
plt.plot(data[:,0], data[:,1])
plt.xlabel("w")
plt.wlabel("Intensity")
plt.show()