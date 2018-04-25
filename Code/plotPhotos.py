import pandas as pd
import folium
from navFiles import getNavData
import argparse
from pyproj import Proj, transform
from rootDir import dataDir, rootDir
import os
import numpy as np

def convertCoordsToLatLng(X, Y):
    
    inProj = Proj(init='epsg:27700')
    outProj = Proj(init='epsg:4326')
    
    lngs, lats = transform(inProj,outProj,X,Y)
    latlngs = zip(lats, lngs)
    latlngs = [[lat, lng] for lat, lng in latlngs]
    
    return latlngs

    
def getDistance(X1, Y1, X2, Y2):

    x_dist = (X1 - X2)*(X1 - X2)
    y_dist = (Y1 - Y2)*(Y1 - Y2)
    norm = np.sqrt(x_dist + y_dist)
    return norm
    
    
def loadPhotos():
    
    file = os.path.join(dataDir(),'A27','sameImages.csv')
    photos = pd.read_csv(file)
    print(photos)
    
    photos['dist_12'] = getDistance(photos['Year1_X'], photos['Year1_Y'], 
                                    photos['Year2_X'], photos['Year2_Y'])
                                    
    photos['dist_13'] = getDistance(photos['Year1_X'], photos['Year1_Y'], 
                                    photos['Year3_X'], photos['Year3_Y'])
    
    photos['dist_23'] = getDistance(photos['Year2_X'], photos['Year2_Y'], 
                                    photos['Year3_X'], photos['Year3_Y'])
    
    
    return photos

    
def generateHTML(file_name, road, year):

    image_url = 'file:///C:/CH2MData/{}/{}/Images/{}'.format( road, year, str(file_name))
    print(image_url)

    html="""
    <h3>{}</h3>
    <p>
   <a href={}> Road Image </a>
    </p>
    """.format(year, image_url)
    return html   
    
    
def main():

    colors = {
    
       'Year1': 'blue',
       'Year2': 'red',
       'Year3': 'green'
    
    }
    
    photos = loadPhotos()
    print(photos)
        
    m = folium.Map([50.8575, -0.9822], zoom_start=13) 
    
    LatLng1 = convertCoordsToLatLng(list(photos['Year1_X']),list(photos['Year1_Y']))
    year1files = list(photos['Year1_File'])
    for ind, LatLng in enumerate(LatLng1):
        html = generateHTML(year1files[ind], 'A27', 'Year1')
        folium.CircleMarker(LatLng, color=colors['Year1'], radius=10, popup=html).add_to(m)
 
    LatLng2 = convertCoordsToLatLng(list(photos['Year2_X']),list(photos['Year2_Y']))
    year1files = list(photos['Year2_File'])
    for ind, LatLng in enumerate(LatLng2):
        html = generateHTML(year1files[ind], 'A27', 'Year2')
        folium.CircleMarker(LatLng, color=colors['Year2'], radius=10, popup=html).add_to(m) 
    
    LatLng3 = convertCoordsToLatLng(list(photos['Year3_X']),list(photos['Year3_Y']))
    year1files = list(photos['Year3_File'])
    for ind, LatLng in enumerate(LatLng3):
        html = generateHTML(year1files[ind], 'A27', 'Year3')
        folium.CircleMarker(LatLng, color=colors['Year3'], radius=10, popup=html).add_to(m)
        
    m.save(os.path.join(rootDir(),'Maps','{}_Photo_Map.html'.format('A27')))
        
if __name__ == '__main__':
    
    main()