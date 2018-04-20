import os
from rootDir import rootDir
from dbfread import DBF
import pandas as pd
import numpy as np

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
    
    nav_file = os.path.join(rootDir(),'Data',road,year,'Nav','{}.dbf'.format(road))
    nav_data = DBF(nav_file)
    nav_data = pd.DataFrame(iter(nav_data))
    print(nav_data.columns)
    print(nav_data[['PITCH','YAW','HEADING','ROLL','HROC','VROC','ALT']].head(10))
    #print(nav_data[['CAM1_LVRX', 'CAM1_LVRY', 'CAM1_LVRZ']].head(10))
    nav_data = nav_data[['ID','XCOORD','YCOORD','LAT','LON','PCDATE','PCTIME']]
    return nav_data
    

def getNavDataInThresh(nav_data, x_target, y_target, distance):

    x_dist = (nav_data['XCOORD'] - x_target)*(nav_data['XCOORD'] - x_target)
    y_dist = (nav_data['YCOORD'] - y_target)*(nav_data['YCOORD'] - y_target)
    norm = np.sqrt(x_dist + y_dist)
    nav_data_thresh = nav_data[norm < distance]
    return nav_data_thresh