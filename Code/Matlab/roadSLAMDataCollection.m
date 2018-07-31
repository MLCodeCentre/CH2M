function roadSLAMDataCollection

% script to collect x,y,z,u,v data points from known target, the user will
% click on the target in the photos, the coordinates of the target relative
% to the car heading are calculated and pixels collected from the click

% THE TARGET IS.. THE SECOND SMALL SQUARE IN THE ROAD WHICH HAS (N,E,Z)
% coords (471321.89, 105924.91, 0)
target = [471294.125; 105930.699; 0];

close all
nav_data = readtable(fullfile(dataDir(),'A27','Year2','Nav','Nav.csv'));

camera = 2;
PCDATE = 2367;
PCTIMES = 1170:1182;

h = 3;

num_files = length(PCTIMES);
data_points = zeros(num_files,5);

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
    Pw = target - photo;
    %Pc - position in camera coords
    Pc = toCameraCoords(Pw,theta);
       
    %% getting U,V from click info
    full_image_file = fullfile(dataDir(),'A27','Year2','Images',image_file);
    I = imread(full_image_file);
    imshow(I);
    [u,v] = ginput(1);
    u = ceil(u);
    v = ceil(v);
    
    data_points(ind,:) = [Pc(2),Pc(1),Pc(3),u,v]
end

disp('saving table to target_data.csv')
file_dir = fullfile(dataDir(),'A27','Year2','target_data.csv');
table = array2table(data_points, 'VariableNames', {'x','y','z','u','v'});
writetable(table,file_dir)

