function roadSLAMDataCollection

% script to collect x,y,z,u,v data points from known target, the user will
% click on the target in the photos, the coordinates of the target relative
% to the car heading are calculated and pixels collected from the click

target_1 = [472077.371; 105732.673; 0]; %right arrow
%target_2 = [472082.638; 105729.771; 0]; %left arrow
%target_3 = [472080.022; 105730.374; 0]; %lane marker after left arrow. 

close all
nav_data = readtable(fullfile(dataDir(),'A27','Year2','Nav','Nav.csv'));

camera = 2;
PCDATE = 2367;
PCTIMES = 759:780;

h = 0;

num_files = length(PCTIMES);
data_points = zeros(num_files,5);
file_names = {};

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
    %Pw2 = target_2 - photo;
    %Pw3 = target_3 - photo;
    %Pc - position in camera coords
    Pc1 = toCameraCoords(Pw1,theta)
    %Pc2 = toCameraCoords(Pw2,theta);
    %Pc3 = toCameraCoords(Pw3,theta);
       
    %% getting U,V from click info
    full_image_file = fullfile(dataDir(),'A27','Year2','Images',image_file);
    I = imread(full_image_file);
    imshow(I);
    [U,V] = ginput(1);
    u1 = ceil(U(1));
    v1 = ceil(V(1));
%     u2 = ceil(U(2));
%     v2 = ceil(V(2));
%     u3 = ceil(U(3));
%     v3 = ceil(V(3));
    data_points(ind,:) = [Pc1(2),Pc1(1),Pc1(3),u1,v1];
    file_names{ind} = full_image_file;
    %data_points(3*ind-2,:) = [Pc1(2),Pc1(1),Pc1(3),u1,v1]
    %data_points(3*ind-1,:) = [Pc2(2),Pc2(1),Pc2(3),u2,v2]
    %data_points(3*ind,:) = [Pc3(2),Pc3(1),Pc3(3),u3,v3]
end

disp('saving table to target_data.csv')
file_dir = fullfile(dataDir(),'A27','Year2','target_data_one_arrow.csv');
data_point_table = array2table(data_points, 'VariableNames', {'x','y','z','u','v'});
file_name_table = cell2table(file_names', 'VariableNames', {'image_file'});
table = [file_name_table, data_point_table];
writetable(table,file_dir)

