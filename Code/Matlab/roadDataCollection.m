function roadDataCollection(road,year,camera,PCDATE,PCTIMES)

% script to collect x,y,z,u,v data points from known target, the user will
% click on the target in the photos, the coordinates of the target relative
% to the car heading are calculated and pixels collected from the click

%% target data
% original road
targets = [471327.998, 105925.655, 0; %first square           
           471323.669, 105922.471, 0;  % divet on the left
           471311.028, 105928.213, 0; % second square
           471319.254, 105922.842, 0]';
           %
           
%  
% targets = [469820.632, 105732.829, 0;
%            469823.987, 105730.202, 0;
%            469826.478, 105729.350, 0]';
       
num_targets = size(targets,2);

close all
nav_data = readtable(fullfile(dataDir(),road,year,'Nav','Nav.csv'));

h = 0;

num_files = length(PCTIMES);
data_points = [];
file_names = {};
%% getting pixels and coords
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
    full_image_file = fullfile(dataDir(),road,year,'Images',image_file);
    I = imread(full_image_file);
    imshow(I);
    [U,V] = ginput(num_targets);
    new_data_point = [Pc', ceil(U), ceil(V)]
    data_points = [data_points; new_data_point];
    for file_names_ind = (ind-1)*num_targets + 1:ind*num_targets
        file_names{file_names_ind} = full_image_file;
    end
    %data_points(3*ind-2,:) = [Pc1(2),Pc1(1),Pc1(3),u1,v1]
    %data_points(3*ind-1,:) = [Pc2(2),Pc2(1),Pc2(3),u2,v2]
    %data_points(3*ind,:) = [Pc3(2),Pc3(1),Pc3(3),u3,v3]
end

file_name = 'target_data_road_4_targets.csv';
fprintf('saving table to %s', file_name);
file_dir = fullfile(dataDir(),road,year,file_name);
data_point_table = array2table(data_points, 'VariableNames', {'y','x','z','u','v'});
file_name_table = cell2table(file_names', 'VariableNames', {'image_file'});
table = [file_name_table, data_point_table];
writetable(table,file_dir)

