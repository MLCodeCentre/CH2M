import cv2
import numpy as np
import os
from rootDir import rootDir  
import glob
from matplotlib import pyplot as plt
import pytesseract
from PIL import Image, ImageEnhance, ImageFilter


def corners(image):

    img = cv2.imread(image,1)
    img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    #gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
    #denoised = cv2.fastNlMeansDenoising(gray, 10,10,7,21)
    cv2.imshow('image', denoised)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    
def match(image, match_image='lampost'):
    
    img = cv2.imread(image,0)
    img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    img = cv2.fastNlMeansDenoising(img, 10,10,7,21)
    
    match_image = os.path.join(rootDir(),'Data','A27','Assets','{}.png'.format(match_image))
    print(match_image)
    match_img = cv2.imread(match_image,0)
    #match_img = cv2.resize(match_img, (0,0), fx=0.25, fy=0.25)
    
    img1 = match_img
    img2 = img
    
    # Initiate SIFT detector
    sift = cv2.xfeatures2d.SIFT_create()

    # find the keypoints and descriptors with SIFT
    kp1, des1 = sift.detectAndCompute(img1,None)
    kp2, des2 = sift.detectAndCompute(img2,None)

    # BFMatcher with default params
    bf = cv2.BFMatcher()
    matches = bf.knnMatch(des1,des2, k=2)

    # Apply ratio test
    good = []
    for m,n in matches:
        if m.distance < 0.75*n.distance:
            good.append([m])

    # cv2.drawMatchesKnn expects list of lists as matches.
    img3 = cv2.drawMatchesKnn(img1,kp1,img2,kp2,good,None,flags=2)

    plt.imshow(img3),plt.show()
  
def getText(image):

    im = Image.open(image) # the second one 
    im = im.filter(ImageFilter.MedianFilter())
    enhancer = ImageEnhance.Contrast(im)
    im = enhancer.enhance(2)
    im = im.convert('1')
    im.save('temp2.jpg')
    text = pytesseract.image_to_string(Image.open('temp2.jpg'))
    print(text)
  
def main():
    
    road = 'A27'
    Year1 = 'Year1'
    Year2 = 'Year2' 
    #dir1 = os.path.join(rootDir(),'Data', road, Year1, 'Images','*.jpg')
    #files_dir1 = glob.glob(dir1)
    #print(files_dir1)
    #pot_hole_file = os.path.join(rootDir(),'Data', road, Year2, 'Images','4_1307_5027.jpeg')
    images = ['1_1307_{}.jpg'.format(str(i)) for i in range(1006, 3700)]
    images = [os.path.join(rootDir(),'Data', road, Year1,'Images',image) for image in images]

    for ind, image in enumerate(images):
        print(image)
        getText(image)

if __name__ == '__main__':
    main()
