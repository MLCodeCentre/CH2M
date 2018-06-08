import cv2
import glob
import os
import numpy as np
from progress.bar import Bar
from matplotlib import pyplot as plt
from rootDir import rootDir, dataDir
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm


def findDifference(surface1, surface2):
    
    gray1 = cv2.cvtColor(surface1, cv2.COLOR_BGR2GRAY)
    gray2 = cv2.cvtColor(surface2, cv2.COLOR_BGR2GRAY)
    
    height = gray1.shape[0]
    width = gray1.shape[1]
    
    kernel_size = (3,3)
    #gray1 = cv2.GaussianBlur(gray1,kernel_size,0)
    #gray2 = cv2.GaussianBlur(gray2,kernel_size,0)
    
    #showImage(gray1)
    #showImage(gray2,'2')
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()
    gray1_mean = np.mean(gray1.ravel())
    gray1_max = np.max(gray1.ravel())
    gray1[gray1>200] = gray1_mean
    
    gray2_mean = np.mean(gray2.ravel())
    gray2_max = np.max(gray2.ravel())
    gray2[gray2>200] = 0
    
    print(gray1.max())
    
    normalised1 = gray1/gray1_max
    normalised2 = gray2/gray2_max
    
    InvNormalised1 = 1 / (normalised1)
    InvNormalised2 = 1 / (normalised2)
    
    print(InvNormalised1.max())
      
    plt.figure()
    plt.imshow(InvNormalised1, vmin=0, vmax=3)
    plt.title('Year1')
    plt.figure()
    plt.imshow(InvNormalised2, vmin=0, vmax=3)
    plt.title('Year2')
    plt.figure()
    difference = normalised1-normalised2
    plt.imshow(difference, vmin=-3, vmax=3)
    #plotSurface(difference)
    #plotSurface(normalised2)
    plt.show()
    
    
def plotSurface(data):
    
    height = data.shape[0]
    width = data.shape[1]
    
    fig = plt.figure()
    ax = fig.gca(projection='3d')

    # Make data.
    X = np.arange(width)
    Y = np.arange(height)
    
    X, Y = np.meshgrid(X, Y)
      
    surf = ax.plot_surface(X, Y, data, cmap=cm.coolwarm,
                           linewidth=0, antialiased=False)
    
    
    
def showImage(file, figure_num="1"):

    if type(file)==str:
        img = cv2.imread(file,1)
        img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    else:
        img = file

    cv2.imshow(figure_num, img)
    