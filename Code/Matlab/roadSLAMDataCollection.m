function roadSLAMDataCollection

% script to collect x,y,z,u,v data points from known target, the user will
% click on the target in the photos, the coordinates of the target relative
% to the car heading are calculated and pixels collected from the click

targets = [471311.005, 105928.217, 0; %first white square
           471251.911, 105932.695, 0; %first chevron
           471267.891, 105939.701, 0; %second post on the right
           471294.136, 105930.674, 0]';%second white sqaure 
       
num_targets = size(targets,2);

close all
nav_data = readtable(fullfile(dataDir(),'A27','Year2','Nav','Nav.csv'));

camera = 2;
PCDATE = 2367;
PCTIMES = 1174;

h = 0;

num_files = length(PCTIMES);
data_points = [];
file_names = {};

disp('click on the target for each photo')

for ind = 1:num_files
    %% getting X Y Z from target and photo information
    PCTIME = PCTIMES(ind);
    % get file from Camera, PCDATE and PCTIME and finding x,y,z
    image_file = strcat(num2str(camera),'_',num2str(PCDATE),'_',num2str(PCTIME),'.jpg');
    image_nav = nav_data(nav_data.PCDATE == PCDATE & nav_data.PCTIME == PCTIME,{'XCOORD','YCOORD','HEADING','PITCH','ROLL'});
    photo = [image_nav.XCOORD, image_nav.YCOORD, h]';
    pan = image_nav.HEADING;
    tilt = image_nav.PITCH;
    roll = image_nav.ROLL;
    
    %Pw - position in (N,E,Z)
    Pw = bsxfun(@minus,targets,photo);
    %Pc - position in camera coords
    Pc = toCameraCoords(Pw,pan,0,0);
    
       
    %% getting U,V from click info
    full_image_file = fullfile(dataDir(),'A27','Year2','Images',image_file);
    I = imread(full_image_file);
    imshow(I);
    [U,V] = ginput(num_targets);
    
    data_points = [data_points; Pc', ceil(U), ceil(V)];
    for file_names_ind = ind:ind + num_targets - 1
        file_names{file_names_ind} = full_image_file;
    end
    %data_points(3*ind-2,:) = [Pc1(2),Pc1(1),Pc1(3),u1,v1]
    %data_points(3*ind-1,:) = [Pc2(2),Pc2(1),Pc2(3),u2,v2]
    %data_points(3*ind,:) = [Pc3(2),Pc3(1),Pc3(3),u3,v3]
end

disp('saving table to target_data.csv')
file_dir = fullfile(dataDir(),'A27','Year2','target_data_road_picture.csv');
data_point_table = array2table(data_points, 'VariableNames', {'y','x','z','u','v'});
file_name_table = cell2table(file_names', 'VariableNames', {'image_file'});
table = [file_name_table, data_point_table];
writetable(table,file_dir)

