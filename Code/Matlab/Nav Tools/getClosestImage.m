function [image,box_min,U_min,V_min] = getClosestImage(nav_file, easting, northing, road, year, camera, min_x, max_y, length, width, height)
% return all photos of road within a distance target easting and northing
% for all years in years.

% loading navFile from that year THINK ABOUT LOADING THESE ONCE AT THE
% START

distances = sqrt((nav_file.XCOORD - easting).^2 + (nav_file.YCOORD - northing).^2);
%distances_from_distance = abs(distances - distance); % this is how close the photo was the argument distance
%min_distance_from_distance = find(distances_from_distance == min(distances_from_distance));
nav_file = nav_file(distances < 30, ...
                   {'XCOORD','YCOORD','HEADING','PCDATE','PCTIME',...
                   'PITCH','ROLL','YAW'});
               
num_pics_close = size(nav_file,1);
Pcs = []; boxes = [];
Us = []; Vs = [];
for pic_num = 1:num_pics_close
    image = nav_file(pic_num,:);
    a = [easting, northing, 0]';
    c = [image.XCOORD,image.YCOORD,0]';
    W = a-c;
    pan = nav_file(pic_num,{'HEADING'}).HEADING;
    Pc = toCameraCoords(W,pan,0,0);
    [u,v,w,h,U,V] = getBoundingBox(Pc(2),Pc(1),Pc(3),year,length,width,height);
    Pcs = [Pcs; Pc'];
    boxes = [boxes; u,v,w,h];
    Us = [Us; U]; Vs = [Vs; V];
end

% getting Photos with positive x;
Pcs_positive_x = Pcs(:,2) > min_x;
nav_file = nav_file(Pcs_positive_x,:);
Pcs = Pcs(Pcs_positive_x,:);
boxes = boxes(Pcs_positive_x,:);
Us = Us(Pcs_positive_x,:);
Vs = Vs(Pcs_positive_x,:);
% good boxes
               % u > 0            v > 0                 u + w < 2000                        v + h < 2000
good_boxes = boxes(:,1) > 0 & boxes(:,2) > 0 & boxes(:,1) + boxes(:,3) < 2000 & boxes(:,2) + boxes(:,4) < 2000;
nav_file = nav_file(good_boxes,:);
Pcs = Pcs(good_boxes,:);
boxes = boxes(good_boxes,:);
Us = Us(good_boxes,:);
Vs = Vs(good_boxes,:);

% getting Photos with small enough y;
Pcs_less_than_max_y = abs(Pcs(:,1)) < max_y;
nav_file = nav_file(Pcs_less_than_max_y,:);
Pcs = Pcs(Pcs_less_than_max_y,:);
boxes = boxes(Pcs_less_than_max_y,:);
Us = Us(Pcs_less_than_max_y,:);
Vs = Vs(Pcs_less_than_max_y,:);

% closest x to distance
min_ind = find(Pcs(:,2)==min(Pcs(:,2)));
nav_file = nav_file(min_ind,:);
Pc_min = Pcs(min_ind,:);
box_min = boxes(min_ind,:);
U_min = Us(min_ind,:);
V_min = Vs(min_ind,:);

File_Name = char(strcat([num2str(num2str(camera)), ...
                 '_',...
                 num2str(nav_file.PCDATE),...
                 '_',...
                 num2str(nav_file.PCTIME),...
                 '.jpg']));
             
Heading = nav_file.HEADING;
Northing = nav_file.XCOORD;
Easting = nav_file.YCOORD;

if size(Pc_min) > 0
    image = table({File_Name}, {year}, {road}, Easting, Northing, Heading,Pc_min(2),Pc_min(1),Pc_min(3),...
                    'VariableNames',{'File_Name','Year','Road','Easting','Northing','Heading','x','y','z'});
else
    image = [];
    box_min = [];
end
end