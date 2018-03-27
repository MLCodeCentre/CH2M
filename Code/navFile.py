import os
from rootDir import rootDir
from dbfread import DBF
import pandas as pd

def main():

    nav_file_year1 = os.path.join(rootDir(),'Data','A27','Year1','Nav','A27.dbf')
    nav_data_year1 = DBF(nav_file_year1)
    nav_data_year1 = pd.DataFrame(iter(nav_data_year1))
    nav_data_year1 = nav_data_year1[['ID','XCOORD','YCOORD','LAT','LON']]
    nav_data_year1.columns = ['ID1','XCOORD','YCOORD','LAT','LON'] 

    print(nav_data_year1.tail(100))
    print(len(nav_data_year1))
    
    nav_file_year2 = os.path.join(rootDir(),'Data','A27','Year2','Nav','A27.dbf')
    nav_data_year2 = DBF(nav_file_year2)
    nav_data_year2 = pd.DataFrame(iter(nav_data_year2))
    nav_data_year2 = nav_data_year2[['ID','XCOORD','YCOORD','LAT','LON']]
    nav_data_year2.columns = ['ID2','XCOORD','YCOORD','LAT','LON']
    
    print(nav_data_year2.head())
    print(len(nav_data_year2))
    
    nav_data = pd.merge(nav_data_year1, nav_data_year2, how='inner', lefton=['XCOORD','YCOORD'])
    print(nav_data.head())
    print(len(nav_data))

if __name__ == '__main__':
	main()
