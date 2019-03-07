function surfaceMosaiac
% Creates a mosiac of the road surface by moving down the road, "length by
% length" and performing a projection transformation.
close all

road = 'A27';
ref_year = 'Year1';
query_year = 'Year2';

num_years = numel({ref_year,query_year});
camera = 2;
min_x = 7; max_y = 4;
length = 10; width = 5; height = 0;

steps = 1;
n_cols = steps;
n_rows = num_years;

% loading navFileStruct
navFileStruct = createNavFileStruct(road);
% define where road mosiac will start.
easting = 471333.339; northing = 105923.666;

for step = 1:steps
    %% find closest image for reference year
    nav_file = navFileStruct(ref_year);
    ref_image = getClosestImage(nav_file, easting, northing, road, ref_year,...
                              camera, min_x, max_y, length, width, height);
                          
    ref_img = imread(fullfile(dataDir(),road,ref_year,'images',char(ref_image.File_Name)));
%     subplot(n_cols, n_rows, 2*(steps-step+1)-1)
%     imshow(ref_img)
    % performing perspective transformation. Buffer now becomes distance
    % from photo to target easting and northing.
    dimensions = [ref_image.x,0,length,width];    
    ref_topDown = getTopDown(ref_year,ref_img,dimensions);
    subplot(n_cols, n_rows, 2*(steps-step+1)-1)
    imshow(ref_topDown);
    
    %% find closest image for query year
    nav_file = navFileStruct(query_year);
    query_image = getClosestImage(nav_file, easting, northing, road, query_year,...
                              camera, min_x, max_y, length, width, height);
                          
    query_img = imread(fullfile(dataDir(),road,query_year,'images',char(query_image.File_Name)));
    width_delta = ref_image.y - query_image.y
    dimensions = [query_image.x,width_delta,length,width];    
    query_topDown = getTopDown(query_year,query_img,dimensions);
    subplot(n_cols, n_rows, 2*(steps-step+1))
    imshow(query_topDown);
    
    %% image registration
    %registerImages(ref_topDown, query_topDown);
   
    %% calculate what the next photo is "length" away
    heading = deg2rad(ref_image.Heading); % heading is defined from N.
    easting = easting + length*sin(heading);
    northing = northing + length*cos(heading);
end % steps


