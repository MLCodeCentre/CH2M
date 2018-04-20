import cv2
import glob
import os
import numpy as np
from progress.bar import Bar
from matplotlib import pyplot as plt
from rootDir import rootDir, dataDir
from imageProcessing import topDownView


def findDifference(surface1, surface2):
    
    gray1 = cv2.cvtColor(surface1, cv2.COLOR_BGR2GRAY)
    gray2 = cv2.cvtColor(surface2, cv2.COLOR_BGR2GRAY)
    
    height = gray1.shape[0]
    width = gray1.shape[1]
    
    # only consider pixels within these ranges    
    minValue = 10
    maxValue = 200
    mask1 = cv2.inRange(gray1, minValue, maxValue)
    mask2 = cv2.inRange(gray2, minValue, maxValue)
    gray1 = cv2.bitwise_and(gray1, mask1)
    gray2 = cv2.bitwise_and(gray2, mask2)
    
    #showImage(gray1)
    
    kernel_size = (5,5)
    gray1 = cv2.GaussianBlur(gray1,kernel_size,0)
    gray2 = cv2.GaussianBlur(gray2,kernel_size,0)
    showImage(gray1)
    showImage(gray2)
    
def showImage(file):

    if type(file)==str:
        img = cv2.imread(file,1)
        img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    else:
        img = file

    cv2.imshow('image', img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()