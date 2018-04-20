import imageio
from rootDir import rootDir
import os
import glob
import shutil


def createGIF(road, XCOORD, YCOORD):

    gif_image_dir = os.path.join(rootDir(),'Gifs',road)
    print(gif_image_dir)
    img_search = os.path.join(gif_image_dir,'*.jpg')
    print(img_search)
    imgs = glob.glob(img_search)   
    print(imgs)
    
    images = []
    for img in imgs:
        print(img)
        images.append(imageio.imread(img))
        
    output_file = os.path.join(rootDir(),'Gifs','{}_{}_{}.gif'.format(road, XCOORD, YCOORD))
    print(output_file)
    imageio.mimsave(output_file, images)
    
    shutil.rmtree(gif_image_dir)
 
 