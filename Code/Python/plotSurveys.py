import pandas as pd
import folium
from navFiles import getNavData
import argparse
from pyproj import Proj, transform
from rootDir import dataDir, rootDir
import os

def convertCoordsToLatLng(X, Y):
    
    inProj = Proj(init='epsg:27700')
    outProj = Proj(init='epsg:4326')
    
    lngs, lats = transform(inProj,outProj,X,Y)
    latlngs = zip(lats, lngs)
    latlngs = [[lat, lng] for lat, lng in latlngs]
    
    return latlngs
    
    
def plotSurveys(years, road):
    
    colors = {
    
       'Year1': 'blue',
       'Year2': 'red',
       'Year3': 'green'
    
    }
    
    m = folium.Map([50.8575, -0.9822], zoom_start=13)
    
    for year in years:
        print(road, year)
        nav_data = getNavData(road, year)
        if year == 'Year2':
            nav_data = nav_data[nav_data['TYPE']=='main']
            
        print(len(nav_data))
        #nav_data = nav_data[0:5000]
        
        coords = nav_data[['XCOORD','YCOORD']]
        latlngs = convertCoordsToLatLng(list(coords['XCOORD']),list(coords['YCOORD']))
        latlngs = latlngs[0::5]
        #print(len(latlngs))
        #folium.PolyLine(latlngs, color=colors[year], weight=2).add_to(m)
        for ind, latlng in enumerate(latlngs):
            print(ind, latlng)
            folium.CircleMarker(latlng, color=colors[year], radius=2).add_to(m)
        
    m.save(os.path.join(rootDir(),'Maps','{}_Survey_Map.html'.format(road)))

    
def plotYear2Types(road):
    
    colors = {
    
       'main': 'blue',
       'other': 'red',

    }
    
    m = folium.Map([50.8575, -0.9822], zoom_start=13)

    nav_data = getNavData(road, 'Year2')
    print(len(nav_data))
    
    every = 4
    coords = nav_data[['XCOORD','YCOORD']]
    coords = coords[0::every]
    types = list(nav_data['TYPE']) 
    types = types[0::every]
    latlngs = convertCoordsToLatLng(list(coords['XCOORD']),list(coords['YCOORD']))
    print(len(latlngs))

    for ind, latlng in enumerate(latlngs):
        print(ind, types[ind])
        folium.CircleMarker(latlng, color=colors[types[ind]], radius=2).add_to(m)
        
    m.save(os.path.join(rootDir(),'Maps','Year2_{}_Survey_Type_Map.html'.format(road)))
    
    
def main(args):

    #plotYear2Types(args.road)
    plotSurveys(args.years, args.road )
    
    
if __name__ == '__main__':
    
    parser = argparse.ArgumentParser(description='Get all photos around a target x and y')
    parser.add_argument('--road', '-r', type=str, help='the time thresholding in processing', default='A27')
    parser.add_argument('--years', '-y', type=str, nargs='+', help='The year label', default=['Year1','Year2','Year3'])
    
    args = parser.parse_args()
    main(args)