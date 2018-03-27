import cv2
import glob
import os
import numpy as np
from progress.bar import Bar
from matplotlib import pyplot as plt
import imageio
from getRoadLines import *
from rootDir import rootDir
import colorsys 

def applyMask(image, points):
    
    mask = np.zeros(image.shape, dtype=np.uint8)
    roi_corners = np.array([points], dtype=np.int32)
    # fill the ROI so it doesn't get wiped out when the mask is applied
    channel_count = image.shape[2]  # i.e. 3 or 4 depending on your image
    ignore_mask_color = (255,)*channel_count
    cv2.fillPoly(mask, roi_corners, ignore_mask_color)
    # from Masterfool: use cv2.fillConvexPoly if you know it's convex

    # apply the mask
    masked_image = cv2.bitwise_and(image, mask)
    return masked_image
    

def cropImage(file):

    img = cv2.imread(file,1)
    img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    #cv2.imshow('image',img)
    #cv2.waitKey()
    #cv2.destroyAllWindows()
    img_road, coords = draw_lanes(img)
    [y_max, y_min, x1_left, x2_left, x1_right, x2_right] = coords
    points = [(x1_left, y_max), (x2_left, y_min), (x2_right, y_min), (x1_right, y_max)]
    img_road = img[y_min:y_max, min(x1_left, x2_left):max(x1_right, x2_right),:]
    #masked_image = applyMask(img,  points)
    
    #gray_mask = grayscale(masked_image)
    cv2.imshow('image',img_road)
    cv2.waitKey()
    cv2.destroyAllWindows()
    
    return img_road, [y_max, y_min, x1_left, x2_left, x1_right, x2_right]


def convertToHSI(img):
    
    print(img.shape)
    (height, width, cols) = img.shape
    HLS = np.zeros((height, width, cols))
    for h in range(height):
        for w in range(width): 
            (r, g, b) = img[h,w,:]
            # I = (1/3)*(r + b + g)
            # S = 1 - ((3/(r + g + b))*min(r,g,b))
            # H = np.arccos((0.5*((r-g) + (r+b)))/(np.sqrt(np.square(r-g) + (r-b)*(g-b))))
            H, L, S = colorsys.rgb_to_hls(r, g, b)
            
            HLS[h,w,0] = H
            HLS[h,w,1] = S
            HLS[h,w,2] = L
            
    cv2.imshow('image',HLS)
    cv2.waitKey()
    cv2.destroyAllWindows()
            
def main():
    
    road = 'A27'
    Year1 = 'Year1'
    Year2 = 'Year2' 
    dir1 = os.path.join(rootDir(),'Data', road, Year1, 'Images','*.jpg')
    files_dir1 = glob.glob(dir1)
    #print(files_dir1)
    #pot_hole_file = os.path.join(rootDir(),'Data', road, Year2, 'Images','4_1307_5027.jpeg')
    pot_hole_file = files_dir1[30010]
    print(pot_hole_file)
    img, [y_max, y_min, x1_left, x2_left, x1_right, x2_right] = cropImage(pot_hole_file)
    convertToHSI(img)
       
   
if __name__ == '__main__':
    main()