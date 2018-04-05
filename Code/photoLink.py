import os
from rootDir import rootDir
from dbfread import DBF
import pandas as pd
import numpy as np
import glob
from imageProcessing import *
import argparse

def getNavData(road, year):
    
    nav_file = os.path.join(rootDir(),'Data',road,year,'Nav','{}.dbf'.format(road))
    nav_data = DBF(nav_file)
    nav_data = pd.DataFrame(iter(nav_data))
    nav_data = nav_data[['ID','XCOORD','YCOORD','LAT','LON','PCDATE','PCTIME']]
    return nav_data
    

def getNavDataInThresh(nav_data, x_target, y_target, distance):

    x_dist = (nav_data['XCOORD'] - x_target)*(nav_data['XCOORD'] - x_target)
    y_dist = (nav_data['YCOORD'] - y_target)*(nav_data['YCOORD'] - y_target)
    norm = np.sqrt(x_dist + y_dist)
    nav_data_thresh = nav_data[norm < distance]
    return nav_data_thresh
        
        
def getPhotoFiles(road, year, cameras, x_target, y_target, distance):
    
    # finding nav_data files for the road and year within a certain euclidean distance of target
    nav_data = getNavData(road, year)
    nav_data_thresh = getNavDataInThresh(nav_data, x_target, y_target, distance) 
    
    # extracting PCDATE and PCTIME as this corresponds to the photo file name.
    # Files have format <camera_num>_<PCDATE>_<PCTIME>.jpg all cameras (1:4) are found.
    photo_files = []
    file_dir = os.path.join(rootDir(),'Data',road,year,'Images')
    for ind, row in nav_data_thresh.iterrows():
        for camera in cameras:
            file_name = '{}_{}_{}.jpg'.format(camera, str(row.PCDATE), str(row.PCTIME))
            files = glob.glob(os.path.join(file_dir, file_name))
            photo_files.extend(files)
    
    return photo_files
        
     
def main(args):
    
    #x_target, y_target = 472940.53000000000, 105979.69000000000
    x_target = args.x_target
    y_target = args.y_target
    road = args.road
    years = args.years
    cameras = args.cameras
    distance = args.distance
    
    for year in years:
        photo_files = getPhotoFiles(road, year, cameras, x_target, y_target, distance)
        for photo in photo_files:
            print(photo)
            #showImage(photo)
            top_down = topDownView(photo)
            showImage(top_down)
                
    
if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Get all photos around a target x and y')
    parser.add_argument('x_target', type=float, nargs=1)
    parser.add_argument('y_target', type=float, nargs=1)
    parser.add_argument('--road', '-r', type=str, help='the time thresholding in processing', default='A27')
    parser.add_argument('--years', '-y', type=str, nargs='+', help='Yhe year label', default=['Year1'])
    parser.add_argument('--cameras', '-c', type=str, nargs='+', help='index of the channel in data array', default=['1','2','3','4'])
    parser.add_argument('--distance', '-d', type=int, nargs=1, default=1) 
    args = parser.parse_args()
    main(args)
