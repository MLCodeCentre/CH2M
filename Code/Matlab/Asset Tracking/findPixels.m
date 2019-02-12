function [x,y,z,u,v] = findPixels(road,year,img)

close all
img_file = fullfile(dataDir(),road,year,'Images',img);
I = imread(img_file);
imshow(I);
hold on

G = I(:,:,2) - I(:,:,1);%
[i,j] = find(G==max(G(:)))
plot(j,i,'ro')

params = cameraConfig();
params = params(year);

image_nav = getNavFromFile(img,'A27',year);
traffic_light = [469885.703; 105604.687];
target_Northing = traffic_light(1); target_Easting = traffic_light(2);
target_height = 1;

Pc = getXYZ([image_nav.XCOORD; image_nav.YCOORD; params.h],...
                    [target_Northing; target_Easting; target_height],...
                     image_nav.HEADING);
x = Pc(1); y = Pc(2); z = 2.2;
[u,v] = getPixelsFromCoords(x,y,z,params);
plot(u,v,'bo')