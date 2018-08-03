function roadSLAMDataCollection

% script to collect x,y,z,u,v data points from known target, the user will
% click on the target in the photos, the coordinates of the target relative
% to the car heading are calculated and pixels collected from the click

% THE 1ST TARGET IS.. THE SECOND WHITE SMALL SQUARE IN THE ROAD WHICH HAS (N,E,Z)
% coords (471321.89, 105924.91, 0)
% THE 2ND TARGET IS.. THE SECOND ORANGE SMALL SQUARE IN THE HARDSHOULDER WHICH HAS (N,E,Z)
% coords (471302.306, 105925.435, 0)

target_1 = [471076.52; 105975.56; 0]; %lane marker sqaure
target_2 = [471070.567; 105978.642; 0]; %

close all
nav_data = readtable(fullfile(dataDir(),'A27','Year2','Nav','Nav.csv'));

camera = 2;
PCDATE = 2369;
PCTIMES = 8551:2:8570;

h = 3;

num_files = length(PCTIMES);
data_points = zeros(2*num_files,5);

disp('click on the target for each photo')

for ind = 1:num_files
    %% getting X Y Z from target and photo information
    PCTIME = PCTIMES(ind);
    % get file from Camera, PCDATE and PCTIME and finding x,y,z
    image_file = strcat(num2str(camera),'_',num2str(PCDATE),'_',num2str(PCTIME),'.jpg');
    image_nav = nav_data(nav_data.PCDATE == PCDATE & nav_data.PCTIME == PCTIME,{'XCOORD','YCOORD','HEADING'});
    photo = [image_nav.XCOORD; image_nav.YCOORD; h];
    theta = image_nav.HEADING;
    %Pw - position in (N,E,Z)
    Pw1 = target_1 - photo;
    Pw2 = target_2 - photo;
    %Pc - position in camera coords
    Pc1 = toCameraCoords(Pw1,theta);
    Pc2 = toCameraCoords(Pw2,theta);
       
    %% getting U,V from click info
    full_image_file = fullfile(dataDir(),'A27','Year2','Images',image_file);
    I = imread(full_image_file);
    imshow(I);
    [U,V] = ginput(2);
    u1 = ceil(U(1));
    v1 = ceil(V(1));
    u2 = ceil(U(2));
    v2 = ceil(V(2));
    
    data_points(2*ind-1,:) = [Pc1(2),Pc1(1),Pc1(3),u1,v1]
    data_points(2*ind,:)   = [Pc2(2),Pc2(1),Pc2(3),u2,v2]
end

disp('saving table to target_data.csv')
file_dir = fullfile(dataDir(),'A27','Year2','target_data.csv');
table = array2table(data_points, 'VariableNames', {'x','y','z','u','v'});
writetable(table,file_dir)

