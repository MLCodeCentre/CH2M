function getSurfaceOverYears(easting,northing)
close all

road = 'A27';
years = {'Year1','Year2'};
num_years = size(years,2);

camera = 2; min_x = 5; max_y = 4; length = 5; width = 2; height = 0;

for year_ind = 1:num_years
    year = years{year_ind};
    
    % finding closest image for that year. Y should be narrow.
    nav_file = readtable(fullfile(dataDir(),road,year,'Nav','Nav.csv'));
    [image,box,U,V] = getClosestImage(nav_file, easting, northing, road, year, camera, min_x, max_y, length, width, height);
    
    % plotting
    figure;
    img_file = fullfile(dataDir(),road,year,'Images',image.File_Name);
    img = imread(char(img_file));
    gray = rgb2gray(img);
    pix = [ceil(U(:)), ceil(V(:))];
    num_pix = size(pix,1);
    for pix_num = 1:num_pix
        pix_val(pix_num) = double(gray(pix(pix_num,1),pix(pix_num,2)));
    end
    hist(pix_val)
%     imshow(img);
%     hold on;
%     plot(U(:),V(:),'ro')
    
end

