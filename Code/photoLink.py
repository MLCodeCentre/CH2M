import os
import sys
import pandas as pd
import numpy as np
import glob
from imageProcessing import *
import argparse
from navFiles import *
      
        
def getPhotoFilesFromTarget(road, year, cameras, x_target, y_target, distance):
    
    # finding nav_data files for the road and year within a certain euclidean distance of target
    nav_data = getNavData(road, year)
    nav_data_thresh = getNavDataInThresh(nav_data, x_target, y_target, distance) 
    
    # extracting PCDATE and PCTIME as this corresponds to the photo file name.
    # Files have format <camera_num>_<PCDATE>_<PCTIME>.jpg all cameras (1:4) are found.
    photo_files = []
    file_dir = os.path.join(rootDir(), 'Data', road,year, 'Images')
    for ind, row in nav_data_thresh.iterrows():
        for camera in cameras:
            file_name = '{}_{}_{}.jpg'.format(camera, str(row.PCDATE), str(row.PCTIME))
            files = glob.glob(os.path.join(file_dir, file_name))
            for file in files:
                photo_files.append((file, road, year, camera, row.XCOORD, row.YCOORD))
    
    return photo_files


def getPhotoFilesFromFile(file, road, year, cameras, distance):
    
    photo_files = []
    
    x_target, y_target = getFileTarget(file, road, year)
    print('photo target is {:f}, {:f}'.format(x_target, y_target))
    if x_target != 0 and y_target != 0:
        photo_files = getPhotoFilesFromTarget(road, year, cameras, x_target, y_target, distance)
    
    return photo_files
     
     
def main(args):

    photo_files = []
    #x_target, y_target = 472940.53000000000, 105979.69000000000 
    if len(args.target) > 0:
        for year in args.years:
            photos = getPhotoFilesFromTarget(args.road, year, args.cameras, args.target[0],
                                        args.target[1], args.distance)
            photo_files.extend(photos)
    
    elif len(args.file) > 0:  
        for year in args.years:
            photos = getPhotoFilesFromFile(args.file, args.road, year, args.cameras, args.distance)
            photo_files.extend(photos)
    else:
        print('No target or file specified')
        sys.exit()
    
    print(photo_files)
    for (photo, road, year, camera, XCOORD, YCOORD) in photo_files:
        print('{} [{}, {}], {}, camera {}'.format(road, XCOORD, YCOORD, year, camera))
        #showImage(photo)
        if int(camera) in [2,4]:
            top_down = topDownView(photo)
                           
    
if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Get all photos around a target x and y')
    parser.add_argument('--target', type=float, nargs='+', help="get photos from target x and y", default=[])
    parser.add_argument('--file', type=str, help="get photos from file", default=[])
    parser.add_argument('--road', '-r', type=str, help='the time thresholding in processing', default='A27')
    parser.add_argument('--years', '-y', type=str, nargs='+', help='The year label', default=['Year1','Year2'])
    parser.add_argument('--cameras', '-c', type=str, nargs='+', help='index of the channel in data array', default=['1','2','3','4'])
    parser.add_argument('--distance', '-d', type=int, nargs=1, default=1)
    
    args = parser.parse_args()
    
    main(args)
