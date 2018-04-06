import cv2
import numpy as np

def showImage(file):

    if type(file)==str:
        img = cv2.imread(file,1)
        img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    else:
        img = file

    cv2.imshow('image', img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    
def topDownView(file):
    
    img = cv2.imread(file,1)
    img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    img_points = img
    [height, width, img_points, points, reference_points] = getRoadPoints(img_points)

    M = cv2.getPerspectiveTransform(points, reference_points)
    top_down = cv2.warpPerspective(img, M, (width, height))
    #top_down = cv2.perspectiveTransform(img, M, (width, height))
    
    return top_down

    
def getRoadPoints(img):
    # img should be an open image array not a file
    height = img.shape[0]
    width = img.shape[1]
    print(width, height)    

    c1 = (int(width*0.2), height)
    #cv2.circle(img,c1, 5, (0,0,255), -1)
    print(c1)
    c2 = (int(width*0.85), height)
    #cv2.circle(img,c2, 5, (0,0,255), -1)
    print(c2)

    theta1 = np.pi/3.3
    theta2 = np.pi/3.7
    r = 200

    c3 = (int(c1[0] + r*np.cos(theta1)), int(c1[1] - r*np.sin(theta1))) 
    #cv2.circle(img,c3, 5, (0,0,255), -1)
    #cv2.line(img, c1, c3, (0,0,255))
    print(c3)

    c4 = (int(c2[0] - r*np.cos(theta2)), int(c2[1] - r*np.sin(theta2))) 
    #cv2.circle(img,c4, 5, (0,0,255), -1)
    #cv2.line(img, c2, c4, (0,0,255))
    print(c4)

    reference_points = np.array([[0,0],[width,0],[0,height],[width,height]], np.float32)
    points = np.array([c3, c4, c1, c2], np.float32)

    return height, width, img, points, reference_points
