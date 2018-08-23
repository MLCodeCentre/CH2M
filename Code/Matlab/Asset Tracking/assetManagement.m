function assetManagement

% this script will collate several crops of a target from different
% images.

config = cameraConfig();

camera = 2;
min_distance = 20;
max_distance = 100;

target_Northing = 470928.06; target_Easting = 105971.046;
images = getImages(target_Northing,target_Easting,'A27',{'Year2'},...
                   camera,min_distance,max_distance);

num_images = size(images,1);

for image_num = 1:10:num_images
    U = [];
    V = [];
    image = images(image_num,:);
    params = config(image.Year);
    
    Pc = getXYZ([image.Northing; image.Easting; params.h],...
                [target_Northing; target_Easting; 1],...
                 image.Heading);
             
    width = 3;
    height = 3;
                  
    x = Pc(1); Y = Pc(2)-width:0.5:Pc(2)+width; Z = -height:0.5:Pc(3)+height;
    %Y = Pc(2);
    if x > 6
        close
        img_file = fullfile(dataDir(),'A27',image.Year,'Images',image.File_Name);
        I = imread(img_file);
        imshow(I);
        hold on
        for y = Y
            [u,v] = getPixelsFromCoords(x,y,Z,params);
            plot(u,v,'ro')
            U = [U,u];
            V = [V,v];
        end
        %pause(0.5)       
        
        XMIN = min(U); WIDTH = max(U) - XMIN;
        YMIN = min(V); HEIGHT = max(V) - YMIN;
        imcrop(I,[XMIN, YMIN, WIDTH, HEIGHT]);
        next = input('Press Enter for next data point');
        
    end
end
