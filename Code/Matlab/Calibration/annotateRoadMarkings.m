function annotateRoadMarkings(navFileM69)
% collecting arrow coordinates for better calibration
arrow_coords = [454091.230  300658.090 0; 454091.202  300657.910 0;
                454114.981  300654.042 0; 454114.875  300653.545 0;
                454122.630  300652.870 0; 454115.097  300654.708 0;
                454115.012  300654.235 0; 454098.169  300656.994 0;
                454110.489  300656.732 0; 454110.479  300656.245 0;
                454117.421  300656.668 0; 454109.623  300657.528 0;
                454110.349  300656.963 0; 454096.382  300657.260 0];
            
            
yellow_lines = [454107.317 300650.015 0; 
                454107.891 300649.952 0;
                454108.528 300656.853 0; 
                454109.101 300656.787 0;
                454114.942 300648.830 0;
                454115.539 300648.745 0;
                454116.030 300655.629 0;
                454116.601 300655.483 0;
                454122.462 300647.546 0;
                454123.084 300647.430 0;
                454123.555 300654.415 0;
                454124.147 300654.300 0];
            
lane_markers = [454091.253 300656.198 0;
                454091.202 300656.098 0;
                454093.093 300655.896 0;
                454093.095 300655.796 0;
                454100.102 300654.758 0;
                454100.102 300654.641 0;
                454101.991 300654.429 0;
                454101.989 300654.318 0;
                454108.892 300653.284 0;
                454108.886 300653.162 0;
                454110.805 300652.943 0;
                454110.808 300652.853 0;
                454118.672 300651.693 0;
                454118.664 300651.602 0;
                454120.960 300651.301 0;
                454120.967 300651.174 0];
            
coords = [arrow_coords; yellow_lines; lane_markers];               
nCoords = size(coords,1)
navImage = navFileM69(navFileM69.PCTIME == 7959, :);
file_name = fullfile(dataDir(), 'M69', 'Images', ...
    sprintf('2_%d_%d.jpg', navImage.PCDATE, navImage.PCTIME));
coords_vehicle = toFrameofVehicle(coords, navImage);
img = loadImage(navImage, 'M69');
imshow(img);
[u,v] = ginput(nCoords);
calibrationData = table(coords_vehicle, u, v);
calibrationData.file_name = repmat({file_name}, nCoords, 1);
save('calibrationDataM69','calibrationData')
end

function vehicle_coords = toFrameofVehicle(coords, image)
% returns each of the arrow coordinates relative to the vehicle.
nCoords = size(coords,1);
vehicle_coords = zeros(size(coords));
% the image metadata
heading = image.HEADING;
xVehicle = [image.XCOORD; image.YCOORD; 0];
for iCoord = 1:nCoords
    coord = coords(iCoord,:)' - xVehicle;
    vehicle_coords(iCoord,:) = toVehicleCoords(coord,heading,0,0);
end
end
