import pandas as pd
import folium
from navFiles import getNavData
import argparse
from pyproj import Proj, transform
from rootDir import rootDir
import os

def convertCoordsToLatLng(X, Y):
    
    inProj = Proj(init='epsg:27700')
    outProj = Proj(init='epsg:4326')
    
    lngs, lats = transform(inProj,outProj,X,Y)
    latlngs = zip(lats, lngs)
    latlngs = [[lat, lng] for lat, lng in latlngs]
    
    return latlngs

    
def main(args):
    
    colors = {
    
       'Year1': 'blue',
       'Year2': 'red'
    
    }
    
    m = folium.Map([50.8575, -0.9822], zoom_start=13)
    
    for year in args.years:
        nav_data = getNavData(args.road, year)
        coords = nav_data[['XCOORD','YCOORD']]
        latlngs = convertCoordsToLatLng(list(coords['XCOORD']),list(coords['YCOORD']))
           
        folium.PolyLine(latlngs, color=colors[year], weight=3, opacity=0.6).add_to(m)
        
    m.save(os.path.join(rootDir(),'Maps','{}_Survey_Map.html'.format(args.road)))
        
if __name__ == '__main__':
    
    parser = argparse.ArgumentParser(description='Get all photos around a target x and y')
    parser.add_argument('--road', '-r', type=str, help='the time thresholding in processing', default='A27')
    parser.add_argument('--years', '-y', type=str, nargs='+', help='The year label', default=['Year1','Year2'])
    
    args = parser.parse_args()
    main(args)