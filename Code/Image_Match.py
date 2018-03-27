from elasticsearch import Elasticsearch
from image_match.elasticsearch_driver import SignatureES
from progress.bar import Bar
import os
import glob
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

def addToDB(files, ses):
    
    bar = Bar('Adding Files to DataBase', max=len(files))
    for file in files:
        
        try:
            ses.add_image(file)
            bar.next()
        except Exception as e:
            print(e.__doc__)
            
        bar.next() 
    bar.finish()
    

def findInDB(files, ses):
    
    image_matches = []
    for file in files:
        matches = ses.search_image(file)
        print(matches)
        if len(matches) > 0:
            img=mpimg.imread(file)
            plt.imshow(img)
            plt.figure()
            #plt.show()
            max_score = 0
            max_file = ''
            for match in matches:
                match_score = match['score']
                match_file = match['path']
                if match_score > max_score:
                    max_score = match_score
                    max_file = match_file
            img=mpimg.imread(max_file)
            plt.imshow(img)
            #plt.figure()
            plt.show()
        
    
    
    
def main():
   
    road = 'A27'
    Year1 = 'Year1'
    Year2 = 'Year2'
    es = Elasticsearch()
    indexName = 'a27year1'
    ses = SignatureES(es, index=indexName, distance_cutoff=0.5)
    #dir1 = os.path.join('Data', road, Year1, 'Images','*.jpg')
    #files_dir1 = glob.glob(dir1)
    #addToDB(files_dir1, ses)
    dir2 = os.path.join('Data', road, Year2, 'Images','*.jpg')
    files_dir2 = glob.glob(dir2)
    findInDB(files_dir2[0::100], ses)
    
    
    
if __name__ == '__main__':
    main()
