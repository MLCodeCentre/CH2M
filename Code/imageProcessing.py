import cv2
import numpy as np

def showImage(file):

    if type(file)==str:
        img = cv2.imread(file,1)
    else:
        img == file

    img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    cv2.imshow('image', img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def topDownView(file):
    
    img = cv2.imread(file,1)
    img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    pts1 = np.float32([[56,65],[368,52],[28,387],[389,390]])
    pts2 = np.float32([[0,0],[300,0],[0,300],[300,300]])
    M = cv2.getPerspectiveTransform(pts1,pts2)
    dst = cv2.warpPerspective(img,M,(300,300))
    showImage(dst)
    return dst