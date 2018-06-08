import os
from rootDir import rootDir, dataDir
from dbfread import DBF
import pandas as pd
import numpy as np
import argparse
import seaborn as sns; sns.set(style="ticks", color_codes=True)
import matplotlib.pyplot as plt


def getFileTarget(file, road, year):

    file_name = file.replace('.jpg','')
    [camera, PCDATE, PCTIME] = file_name.split('_')[0:3]
    nav_file = getNavData(road, year)

    photo_nav_file = nav_file[(nav_file['PCDATE'] == PCDATE) & (nav_file['PCTIME'] == PCTIME)]
    if len(photo_nav_file) > 0:
        x_target = photo_nav_file.iloc[0,:]['XCOORD']
        y_target = photo_nav_file.iloc[0,:]['YCOORD']
    else:
        x_target = 0
        y_target = 0
    
    return x_target, y_target
    
   
def getNavData(road, year):
    
    nav_file = os.path.join(dataDir(),road,year,'Nav','{}.dbf'.format(road))
    nav_data = DBF(nav_file)
    nav_data = pd.DataFrame(iter(nav_data))
    #print(nav_data.head(10))
    print(nav_data.columns)
    
    if year == 'Year2':
        nav_data = nav_data[['ID','XCOORD','YCOORD','LAT','LON','PCDATE','PCTIME','TYPE','YAW']]
    else:
        nav_data = nav_data[['ID','XCOORD','YCOORD','LAT','LON','PCDATE','PCTIME']]
        
    return nav_data
    

def getNavDataInThresh(nav_data, x_target, y_target, distance):

    x_dist = (nav_data['XCOORD'] - x_target)*(nav_data['XCOORD'] - x_target)
    y_dist = (nav_data['YCOORD'] - y_target)*(nav_data['YCOORD'] - y_target)
    norm = np.sqrt(x_dist + y_dist)
    nav_data_thresh = nav_data[norm < distance]
    
    return nav_data_thresh
    

def getNavDataFromFile(year, road, file):
    
    YearNavFile = getNavData(road,year)
    
    if len(file) > 0:
        file_name = file.replace('.jpg','')
        [camera, PCDATE, PCTIME] = file_name.split('_')[0:3]
        YearNavFile = YearNavFile[(YearNavFile['PCDATE'] == PCDATE) & (YearNavFile['PCTIME'] == PCTIME)]
    print(YearNavFile.head(10))
    
   
if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Get nav information about a specific file')
    parser.add_argument('year', type=str, help='the year')
    parser.add_argument('file', type=str, help='the file in the year')
    parser.add_argument('--road', '-r', type=str, help='the road', default='A27')
    
    args = parser.parse_args()
    
    getNavDataFromFile(args.year, args.road, args.file)
