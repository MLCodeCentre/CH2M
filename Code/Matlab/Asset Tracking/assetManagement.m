function assetManagement

% this script will collate several crops of a target from different
% images.

config = cameraConfig();

camera = 2;
min_distance = 10;
max_distance = 30;

years = {'Year1','Year2'};
%years = {'Year1'}
num_years = length(years);

for year_ind = 1:num_years
    
    year = years{year_ind};
    target_Northing = 469621.023; target_Easting = 105972.694; target_height = 0;
    images = getImages(target_Northing,target_Easting,'A27',year,...
                   camera,min_distance,max_distance);

    num_images = size(images,1);

    for image_num = 1:2:num_images
        U = [];
        V = [];
        image = images(image_num,:)
        params = config(image.Year);

        Pc = getXYZ([image.Northing; image.Easting; params.h],...
                    [target_Northing; target_Easting; target_height],...
                     image.Heading)

        width = 1;
        height = 10;

        x = Pc(1); y = Pc(2); z = Pc(3);
        Y = y-width:y+width;
        Z = 0:0+height;
        
        if x > 12 & abs(y) < 8 
            [x,y,z]
            close all
            img_file = fullfile(dataDir(),'A27',image.Year,'Images',erase(image.File_Name,' '));
            I = imread(img_file);
            imshow(I); hold on

            for y = Y
                for z = Z
                    [u,v] = getPixelsFromCoords(x,y,z,params);
                    plot(u,v,'ro')
                    U = [U,u];
                    V = [V,v];
                end
            end
            
%             for y = -4:4
%                 for x = 5:20
%                     [u,v] = getPixelsFromCoords(x,y,0,params);
%                     plot(u,v,'bo')
%                     U = [U,u];
%                     V = [V,v];
%                 end
%             end

            Umin = max(0,min(U)); Umax = min(params.m,max(U));
            Vmin = max(0,min(V)); Vmax = min(params.n,max(V));
            width = Umax - Umin; height = Vmax - Vmin;
            crop = imcrop(I,[Umin,Vmin,width,height]);

            crop_resized = imresize(crop,[params.m/4,params.n/4]);
            %imshow(crop_resized)

            file = strcat([image.Year,'_',image.File_Name]);
            out_dir = fullfile(dataDir(),'Asset Monitoring','A27');
            out_file = fullfile(out_dir, file);
            imwrite(crop,out_file);
            next = input('Press Enter for next data point');

        end
    end
end
