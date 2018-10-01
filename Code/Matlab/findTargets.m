function findTargets(params)

file_dir = fullfile(dataDir(),'A27','Year2','target_data.csv');
data_points = readtable(file_dir);

num_rows = size(data_points,1);

camera = 2;
PCDATE = 2369;
PCTIMES = 449:464;

num_files = length(PCTIMES);

disp('click on the target for each photo')

for ind = 1
    close all 
    %% getting X Y Z from target and photo information
    PCTIME = PCTIMES(ind);
    % get file from Camera, PCDATE and PCTIME and finding x,y,z
    image_file = strcat(num2str(camera),'_',num2str(PCDATE),'_',num2str(PCTIME),'.jpg');
    full_image_file = fullfile(dataDir(),'A27','Year2','Images',image_file);
    I = imread(full_image_file);
    imshow(I);
    hold on
    for D = 3*(ind)-2:3*ind 
        data_point = data_points(D,:);
        U = data_point.u;
        V = data_point.v;
        X = data_point.x;
        Y = data_point.y;
        Z = -2.5; 

        [u_hat,v_hat] = cameraEquationFunction(params,[X,Y,Z]);
        plot(u_hat,v_hat,'r*')
    end
    pause(0.5)

end