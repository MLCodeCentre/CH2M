import os
import sys
import pandas as pd
import numpy as np
import glob
from imageProcessing import *
import argparse
from navFiles import *
from makeGIF import createGIF

   
def getNearestPhoto(photos, x_target, y_target):

    x_dist = (photos['XCOORD'] - x_target)*(photos['XCOORD'] - x_target)
    y_dist = (photos['YCOORD'] - y_target)*(photos['YCOORD'] - y_target)
    norm = np.sqrt(x_dist + y_dist)
    nearest_photo = photos.iloc[norm.idxmin()]
    
    return nearest_photo
      
        
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


def getPhotoFilesFromFile(file, road, years, cameras, distance):
    
    photo_files = []
    x_target = 0 
    y_target = 0
    for year in years:
        if x_target == 0 and y_target == 0:
            x_target, y_target = getFileTarget(file, road, year)
        
    print('photo target is {:f}, {:f}'.format(x_target, y_target))
    
    if x_target != 0 and y_target != 0:
        for year in years:
            photo_files_year = getPhotoFilesFromTarget(road, year, cameras, x_target, y_target, distance)
            photo_files.extend(photo_files_year)
        
    return photo_files, x_target, y_target
     
     
def main(args):

    photo_files = []
    #x_target, y_target = 472940.53000000000, 105979.69000000000 
    if len(args.target) > 0:
        for year in args.years:
            photos = getPhotoFilesFromTarget(args.road, year, args.cameras, args.target[0],
                                        args.target[1], args.distance)
            photo_files.extend(photos)
    
    elif len(args.file) > 0:  
            [photos, x_target, y_target] = getPhotoFilesFromFile(args.file, args.road, args.years, args.cameras, args.distance)
            photo_files.extend(photos)
    else:
        print('No target or file specified')
        sys.exit()
    
    photo_df = pd.DataFrame(photo_files)
    photo_df.columns = ['file', 'road', 'year', 'camera', 'XCOORD', 'YCOORD']
    
    year1_photos = photo_df[photo_df['year']=='Year1']
    year1_photos = year1_photos.reset_index()
    year2_photos = photo_df[photo_df['year']=='Year2']
    year2_photos = year2_photos.reset_index()
    
    print('There are {:d} photos in Year {}'.format(len(year1_photos), '1'))
    print('There are {:d} photos in Year {}'.format(len(year2_photos), '2'))  
    
    for ind, photo in year1_photos.iterrows():
        nearest_photo = getNearestPhoto(year2_photos, photo.XCOORD, photo.YCOORD)
        for camera in args.cameras:
            if int(photo.camera) in [2,4]:
                top_down, road_img = topDownView(photo['file'])
                top_down_neareast, road_img_nearest = topDownView(nearest_photo['file'])
                if args.surface:
                    showMultiWindow4(road_img, road_img_nearest, top_down, top_down_neareast, args.road, photo['file'].split('\\')[-1], args.gif)
                else:
                    showMultiWindow2(road_img, road_img_nearest)
    
    if args.gif:
        createGIF(args.road, str(x_target), str(y_target))

    
if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Get all photos around a target x and y')
    parser.add_argument('--target', type=float, nargs='+', help="get photos from target x and y", default=[])
    parser.add_argument('--file', type=str, help="get photos from file", default=[])
    parser.add_argument('--road', '-r', type=str, help='the time thresholding in processing', default='A27')
    parser.add_argument('--years', '-y', type=str, nargs='+', help='The year label', default=['Year1','Year2'])
    parser.add_argument('--cameras', '-c', type=str, nargs='+', help='index of the channel in data array', default=['1','2','3','4'])
    parser.add_argument('--distance', '-d', type=int, nargs=1, default=1)
    parser.add_argument('--surface',  type=str, const=True, nargs='?', help="show image of road surface.")
    parser.add_argument('--gif',  type=str, const=True, nargs='?', help="create gif")
    
    args = parser.parse_args()
    
    main(args)
