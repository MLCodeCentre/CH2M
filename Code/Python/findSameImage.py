import cv2
import glob
import os
import numpy as np
from rootDir import rootDir
from progress.bar import Bar
from PIL import Image
import piexif
from PIL.ExifTags import TAGS, GPSTAGS 
import subprocess
    
def main():
    
    road = 'A27'
    Year1 = 'Year1'
    Year2 = 'Year2' 
    dir1 = os.path.join(rootDir(),'Data', road, Year1, 'Images','*.jpg')
    files_dir1 = glob.glob(dir1)
    
    dir2 = os.path.join(rootDir(),'Data', road, Year2, 'Images','*.jpg')
    files_dir2 = glob.glob(dir2)
    
    image = files_dir1[0]
    findSameImage(image, files_dir2)

if __name__ == '__main__':
    main()