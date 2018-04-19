import cv2
import os
from rootDir import rootDir, dataDir
from imageProcessing import showImage
import numpy as np


def getUVProjection(x, y, h, d, l, theta, gamma, alpha, n):
    
    theta = np.deg2rad(theta)
    alpha = np.deg2rad(alpha)
    
    u = (np.arctan((h*np.sin(np.arctan((y-d)/(x-l))))/(y-d)) - (theta - alpha)) / ((2*alpha)/(n-1))
    v = (np.arctan((y-d)/(x-l)) - (gamma - alpha)) / ((2*alpha)/(n-1))
    
    u = int(u)
    v = int(v)
    print(x,u, y, v)
    return(u, v)


def getXYProjection(u, v, h, theta, alpha, n, m):

    theta = np.deg2rad(theta)
    alpha = np.deg2rad(alpha)
    
    X = h * ((np.tan(theta) * (1 - (2*(v-1)/(n-1))) * np.tan(alpha)) - 1) / np.tan(theta) + ((1 -(2*(v-1)/(n-1)))*np.tan(alpha))
            
    Y = (1 - (2*(v-1)/(n-1))) * np.tan(alpha) * X

    Z = 0
    #print(X,Y,Z)
    return(X,Y,Z)
    
def findGround(img_file):

    img = cv2.imread(img_file,1)
    img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    #showImage(img)
    print(img.shape)
    height, width = img.shape[0], img.shape[1]
   
    theta = 15
    alpha = 1
    gamma = 0
    d = 0
    l = 0
    h = 1
    n = height
    m = width
    #getProjection(u,v,h,theta,alpha,n,m)
    x = 30
    U = []
    V = []
   
    for y in np.arange(1,500,10):
        cv2.circle(img,(x,y), 5, (0,255,0), -1)
        u,v = getUVProjection(x, y, h, d, l, theta, gamma, alpha, n)
        cv2.circle(img,(u,v), 5, (0,0,255), -1)
    
    showImage(img)
    
def main():

    img_file = os.path.join(dataDir(),'A27','Year1','Images','2_1310_4269.jpg')
    findGround(img_file)

if __name__ == '__main__':
    
    main()