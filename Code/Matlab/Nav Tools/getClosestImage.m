function [image, box_min, target_pixels] = getClosestImage(nav_file, easting, northing, z, road, year, camera, min_x, max_x, max_y, length, width, height, camera_params)
% return all photos of road within a distance target easting and northing
% for all years in years.

% loading navFile from that year THINK ABOUT LOADING THESE ONCE AT THE
% START

distances = sqrt((nav_file.XCOORD - easting).^2 + (nav_file.YCOORD - northing).^2);
%distances_from_distance = abs(distances - distance); % this is how close the photo was the argument distance
%min_distance_from_distance = find(distances_from_distance == min(distances_from_distance));
nav_file = nav_file(distances < max_x, ...
                   {'XCOORD','YCOORD','HEADING','PCDATE','PCTIME',...
                   'PITCH','ROLL','YAW'});
               
num_pics_close = size(nav_file,1);
Pcs = []; boxes = [];
pixels = [];

for pic_num = 1:num_pics_close
    image = nav_file(pic_num,:);
    a = [easting, northing, z]';
    c = [image.XCOORD,image.YCOORD,0]';
    W = a-c;
    pan = nav_file(pic_num,{'HEADING'}).HEADING;
    tilt = nav_file(pic_num,{'PITCH'}).PITCH;
    roll = nav_file(pic_num,{'ROLL'}).ROLL;
    Pc = toCameraCoords(W,pan,0,0);
    %Pc = toCameraCoords(W,pan,tilt,roll);
    [u,v,w,h,~,~] = getBoundingBox(Pc(2),Pc(1),Pc(3),year,length,width,height,camera_params);
    Pcs = [Pcs; Pc'];
    boxes = [boxes; u,v,w,h];
    [u,v] = getPixelsFromCoords(Pc(2),Pc(1),Pc(3),camera_params(year));
    pixels = [pixels; u,v];
end

% getting Photos with positive x;
Pcs_positive_x = Pcs(:,2) > min_x;
nav_file = nav_file(Pcs_positive_x,:);
Pcs = Pcs(Pcs_positive_x,:);
boxes = boxes(Pcs_positive_x,:);
pixels = pixels(Pcs_positive_x,:);

% getting Photos with small enough y;
Pcs_less_than_max_y = abs(Pcs(:,1)) < max_y;
nav_file = nav_file(Pcs_less_than_max_y,:);
Pcs = Pcs(Pcs_less_than_max_y,:);
boxes = boxes(Pcs_less_than_max_y,:);
pixels = pixels(Pcs_less_than_max_y,:);

% are pixels in picture
good_pixels = pixels(:,1) < 2500 & pixels(:,1) > 40 & pixels(:,2) < 2000  & pixels(:,2) > 200;
nav_file = nav_file(good_pixels,:);
Pcs = Pcs(good_pixels,:);
boxes = boxes(good_pixels,:);
pixels = pixels(good_pixels,:);

% good boxes
good_boxes = boxes(:,1) > 0 & boxes(:,1) + boxes(:,3) < 2500 ... 
            & boxes(:,2) > 0 & boxes(:,2) + boxes(:,4) < 2000;
if sum(good_boxes) > 0
    nav_file = nav_file(good_boxes,:);
    Pcs = Pcs(good_boxes,:);
    boxes = boxes(good_boxes,:);
    pixels = pixels(good_boxes,:);
end

% closest
distances = sqrt(Pcs(:,1).^2 + Pcs(:,2).^2 + Pcs(:,3).^2);
%min_ind = find(Pcs(:,2)==min(Pcs(:,2)));
min_ind = find(distances==min(distances));
nav_file = nav_file(min_ind,:);
Pc_min = Pcs(min_ind,:);
box_min = boxes(min_ind,:);
pixels_min = pixels(min_ind,:);

File_Name = char(strcat([num2str(num2str(camera)), ...
                 '_',...
                 num2str(nav_file.PCDATE),...
                 '_',...
                 num2str(nav_file.PCTIME),...
                 '.jpg']));
             
Heading = nav_file.HEADING;
Northing = nav_file.XCOORD;
Easting = nav_file.YCOORD;

Tilt = nav_file.PITCH;
Roll = nav_file.ROLL;

if size(Pc_min) > 0
    image = table({File_Name}, {year}, {road}, Easting, Northing, Heading, Tilt, Roll, Pc_min(2), Pc_min(1), Pc_min(3),...
                    'VariableNames',{'File_Name','Year','Road','Easting','Northing','Heading','Tilt','Roll','x','y','z'});
    target_pixels = pixels_min;
else
    image = [];
    box_min = [];
    target_pixels = [];
end
end