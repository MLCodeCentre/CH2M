import cv2
import numpy as np
from roadUtils import *
from matplotlib import pyplot as plt
import os
from rootDir import rootDir


def showMultiWindow4(img1, img2, surface_img1, surface_img2, road, file_name, gif):
    
    if gif:
        gif_image_dir = os.path.join(rootDir(),'Gifs',road)
        if not os.path.exists(gif_image_dir):
            os.makedirs(gif_image_dir)
    try:
        img1 = cv2.cvtColor(img1, cv2.COLOR_BGR2RGB)
        img2 = cv2.cvtColor(img2, cv2.COLOR_BGR2RGB)
        surface_img1 = cv2.cvtColor(surface_img1, cv2.COLOR_BGR2RGB)
        surface_img2 = cv2.cvtColor(surface_img2, cv2.COLOR_BGR2RGB)
    except:
        print("Caught OpenCV error!")
    
    plt.subplot(2,2,1), plt.imshow(img1), plt.title('Year1'), plt.axis('off')
    plt.subplot(2,2,2), plt.imshow(img2), plt.title('Year2'), plt.axis('off')
    plt.subplot(2,2,3), plt.imshow(surface_img1), plt.axis('off')
    plt.subplot(2,2,4), plt.imshow(surface_img2), plt.axis('off') 
        
    if gif:
        out_file = os.path.join(gif_image_dir, file_name)
        plt.savefig(out_file)
    else:
        plt.show()

        
def showMultiWindow2(img1, img2):

    img1 = cv2.cvtColor(img1, cv2.COLOR_BGR2RGB)
    img2 = cv2.cvtColor(img2, cv2.COLOR_BGR2RGB)
    plt.subplot(1,2,1), plt.imshow(img1), plt.title('Year1'), plt.axis('off')
    plt.subplot(1,2,2), plt.imshow(img2), plt.title('Year2'), plt.axis('off')
    plt.show()    

    
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
    
    #[height, width, img_points, points, reference_points] = getRoadPoints(img_points)
    [height, width, img, points, reference_points] = autoRoadPoints(img)
    
    top_down = np.zeros(img.shape)
    
    if 0 not in points:
        M = cv2.getPerspectiveTransform(points, reference_points)
        top_down = cv2.warpPerspective(img, M, (width, height))
        #showImage(top_down)
    return top_down, img
    
def autoRoadPoints(img):
    
    height = img.shape[0]
    width = img.shape[1]

    gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # defining a region of interest infront of the car in which the lines will be found. 
    points = regionOfInterest(gray_image, height, width)
    mask_roi = np.zeros([height, width])
    mask_roi = cv2.fillPoly(mask_roi, [points], 255)
    mask_roi = cv2.inRange(mask_roi, 200, 255)
    mask_roi_image = cv2.bitwise_and(gray_image, mask_roi)
    
    # showImage(mask_roi_image)
    
    # reference_points = np.array([[0,0],[width,0],[0,height],[width,height]], np.float32)   
    upper_yellow = np.array([30, 255, 255], dtype='uint8')
    
    # we only need to use a white line detector - no yellows
    mask_white = cv2.inRange(mask_roi_image, 250, 255)
    mask_white_image = cv2.bitwise_and(mask_roi_image, mask_white)
    
    # showImage(mask_white_image)
    
    # we now apply a blur to get rid of some of the noise.
    kernel_size = (5,5)
    gauss_gray = cv2.GaussianBlur(mask_white_image,kernel_size,0)
    # showImage(gauss_gray)
    
    # canny edge detection
    low_threshold = 50
    high_threshold = 150
    canny_edges = cv2.Canny(gauss_gray,low_threshold,high_threshold)
    # showImage(canny_edges)
    
    lines = cv2.HoughLinesP(canny_edges,4,np.pi/180,30, np.array([]), minLineLength=10, maxLineGap=150)
    
    if lines is None:
        bl = (0, 0) 
        tl = (0, 0)
        br = (0, 0)
        tr = (0, 0)
        
    else:
        left_line, right_line = averageLines(lines)
           
        left_line = cleanLine(left_line)
        right_line = cleanLine(right_line)
        
        # showing hough lines
        lx1, ly1, lx2, ly2 = left_line
        rx1, ry1, rx2, ry2 = right_line
                         
        cv2.line(img, (lx1, ly1), (lx2, ly2), (0, 0, 255), 2)
        cv2.line(img, (rx1, ry1), (rx2, ry2), (0, 0, 255), 2)
        
        # extending shorter line
        lx1, ly1, lx2, ly2 = left_line
        rx1, ry1, rx2, ry2 = right_line
            
        # y1_target = max(ly1, ry1)
        # y2_target = min(ly2, ry2)
        # how about making y targets always the same????
        y1_target = height
        y2_target = 300
    
        if 0 not in left_line and 0 not in right_line:
            left_line = extendLine(left_line, y1_target, y2_target)
            right_line = extendLine(right_line, y1_target, y2_target)
        # showing extensions
        lx1_ext, ly1_ext, lx2_ext, ly2_ext = left_line
        rx1_ext, ry1_ext, rx2_ext, ry2_ext = right_line
                     
        cv2.line(img, (lx1, ly1), (lx1_ext, ly1_ext), (0, 255, 0), 2)
        cv2.line(img, (lx2, ly2), (lx2_ext, ly2_ext), (0, 255, 0), 2)
        cv2.line(img, (rx1, ry1), (rx1_ext, ry1_ext), (0, 255, 0), 2)
        cv2.line(img, (rx2, ry2), (rx2_ext, ry2_ext), (0, 255, 0), 2)   
    
        # drawing line
        # showImage(img)
        
        bl = (lx1_ext, ly1_ext) 
        tl = (lx2_ext, ly2_ext)
        br = (rx1_ext, ry1_ext)
        tr = (rx2_ext, ry2_ext)
    
   
    points = np.array([tl, tr, bl, br], dtype=np.float32)
    reference_points = np.array([[0,0], [width,0], [0,height], [width,height]], dtype=np.float32)
    
    return height, width, img, points, reference_points  

