function monitorSurface

road = 'A27';
camera = '2'; year = 'Year2';
PCDATE = '2369'; PCTIMEs = 3447:2:3745;
%nav_file = readtable(fullfile(dataDir(),year,road,'Nav','Nav.csv'));
params_all = cameraConfig();
params = params_all(year);


num_files = size(PCTIMEs,2);
for file_num = 1:num_files
    close
    % get nav file information for heading and location. 
    file_name = strcat([camera,'_',PCDATE,'_',num2str(PCTIMEs(file_num)),'.jpg']);
    %% for each file we will now find the surface of the road that is a 10x3 m
    % segment. Buffer is distance infront of the car. 
    buffer = 6; length = 4; half_width = 1.5;
    corners = [buffer,        -half_width;  buffer+length, -half_width;  ...
               buffer+length,  half_width;  buffer,         half_width;];
    % This kept flexible so any polygon can be specified in corners. 
    num_corners = size(corners,1);
    img = imread(fullfile(dataDir(),year,road,'Images',file_name));
    gray = rgb2gray(img);
    for corner_num = 1:num_corners
        % get x,y,z coords of road surface segment and corresponding
        % pixels.
        x = corners(corner_num,1); y = corners(corner_num,2); z = 0; 
        [u,v] = getPixelsFromCoords(x,y,z,params);
        polygon(corner_num,:) = [u,v];
        U(corner_num) = u; V(corner_num) = v;         
    end
    
    mask = roipoly(img,U,V);
    surface = int8(gray).*int8(mask);
    plotPixelHists(surface)
    pause(2)
    
end