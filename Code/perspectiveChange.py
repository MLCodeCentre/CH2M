import cv2
import os
from rootDir import rootDir
from imageProcessing import showImage
import numpy as np


def getProjection(X, Y, Z0, Lambda, alpha):
    # alpha = degrees
    #alpha = np.deg2rad(alpha)    
    d = Y*np.sin(alpha) + Z0*np.cos(alpha) + Lambda
    
    x = (Lambda*X) / d 
    y = (Lambda*(Y*np.cos(alpha) - Z0*np.sin(alpha))) / d
    
    return(x, y)
    

def findGround(img_file):

    img = cv2.imread(img_file,1)
    img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    showImage(img)
    
    height, width = img.shape[0], img.shape[1]
   
    print(height, width)
    Z0 = 1 
    Lambda = 0.035
    alpha = 0.011
    x,y = getProjection(400, 300, Z0, Lambda, alpha)
    print(x,y)
    
def main():

    img_file = os.path.join(rootDir(),'Data','A27','Year1','Images','2_1310_4269.jpg')
    findGround(img_file)

if __name__ == '__main__':
    
    main()