import cv2
import os
from matplotlib import pyplot as plt
from imageProcessing import topDownView
from rootDir import rootDir
from findDamages import findDifference


def showImage(file):

    if type(file)==str:
        img = cv2.imread(file,1)
        img = cv2.resize(img, (0,0), fx=0.25, fy=0.25)
    else:
        img = file

    cv2.imshow('image', img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    
def showMultiWindow(nearest_photos, road, gif):
    
    if gif:
        gif_image_dir = os.path.join(rootDir(),'Gifs',road)
        if not os.path.exists(gif_image_dir):
            os.makedirs(gif_image_dir)
    
    number_years = len(nearest_photos.keys())
    photo_position = 1
    surfaces = {}
    
    for year, photo in nearest_photos.items():

        print(year, photo['XCOORD'], photo['YCOORD'])

        top_down, road_img = topDownView(photo['file'], auto_detection=False)
        surfaces[year] = top_down
        try:
            road_img = cv2.cvtColor(road_img, cv2.COLOR_BGR2RGB)
            top_down = cv2.cvtColor(top_down, cv2.COLOR_BGR2RGB)
        except:
            print("Caught OpenCV error!")
        plt.subplot(2,number_years,photo_position), plt.imshow(road_img), plt.title(year), plt.axis('off')
        plt.subplot(2,number_years,photo_position+number_years), plt.imshow(top_down), plt.axis('off')
        photo_position = photo_position + 1
            
    findDifference(surfaces['Year1'], surfaces['Year2'])
 
    if gif:
        file_name = nearest_photos['Year1']['file'].split('\\')[-1]
        out_file = os.path.join(gif_image_dir, file_name)
        print(out_file)
        plt.savefig(out_file)
    else:
        plt.show()

        
def showMultiWindow2(nearest_photos):

    number_years = len(nearest_photos.keys())
    photo_position = 1
    for year, photo in nearest_photos.items():

        road_img = cv2.imread(photo['file'],1)
        road_img = cv2.resize(road_img, (0,0), fx=0.25, fy=0.25)
        
        try:
            road_img = cv2.cvtColor(road_img, cv2.COLOR_BGR2RGB)   
        except:
            print("Caught OpenCV error!")
            
        plt.subplot(1,number_years,photo_position), plt.imshow(road_img), plt.title(year), plt.axis('off')
        photo_position = photo_position + 1   
    
    plt.show()   