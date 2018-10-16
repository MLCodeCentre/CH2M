function assetManagement

% this script will collate several crops of a target from different
% images.

config = cameraConfig();

camera = 2;
min_distance = 10;
max_distance = 50;

target_Northing = 470928.06; target_Easting = 105971.046; target_height = 1;
images = getImages(target_Northing,target_Easting,'A27',{'Year1','Year2'},...
                   camera,min_distance,max_distance);

num_images = size(images,1);

for image_num = 1:10:num_images
    U = [];
    V = [];
    image = images(image_num,:);
    params = config(image.Year);
    
    Pc = getXYZ([image.Northing; image.Easting; params.h],...
                [target_Northing; target_Easting; target_height],...
                 image.Heading);
             
    width = 3;
    height = 3;
                  
    x = Pc(1); y = Pc(2); z = Pc(3);
    %Y = Pc(2);
    if x > 6 & y < 10 
        close all
        img_file = fullfile(dataDir(),'A27',image.Year,'Images',image.File_Name);
        I = imread(img_file);
        %imshow(I);
        %hold on

        [u,v] = getPixelsFromCoords(x,y,z,params);
        %plot(u,v,'ro')
        %pause(0.5)       
        CW = 250;
        XMIN = u - CW; WIDTH = 2*CW;
        YMIN = v - CW; HEIGHT = 2*CW;
        crop = imcrop(I,[XMIN, YMIN, WIDTH, HEIGHT]);
        crop_resized = imresize(crop,[512,512]);
        
        file = strcat([image.Year,'_',image.File_Name]);
        out_dir = fullfile(dataDir(),'Asset Monitoring','A27');
        out_file = fullfile(out_dir, file);
        imwrite(crop,out_file);
        %next = input('Press Enter for next data point');
        
    end
end
