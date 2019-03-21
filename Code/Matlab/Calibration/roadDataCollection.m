function roadDataCollection(road,year,camera,PCDATE,PCTIMES)

% script to collect x,y,z,u,v data points from known target, the user will
% click on the target in the photos, the coordinates of the target relative
% to the car heading are calculated and pixels collected from the click

% target data with height info
target_table = readtable(fullfile(dataDir(),road,'Targets','targets in the plane.csv'));
targets = table2array(target_table);
%targets(7,:) = []
targets = targets(:,2:end)';


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
    Pc = toVehicleCoords(Pw,pan,0,0);
    %Pc = toCameraCoords(Pw,pan,tilt,roll);    
       
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

end

file_name = 'target_data_in_the_plane.csv';
fprintf('saving table to %s\n', file_name);
file_dir = fullfile(dataDir(),road,year,file_name);
data_point_table = array2table(data_points, 'VariableNames', {'x','y','z','u','v'});
file_name_table = cell2table(file_names', 'VariableNames', {'image_file'});
table = [file_name_table, data_point_table];
writetable(table,file_dir)
