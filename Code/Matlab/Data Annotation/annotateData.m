function annotateData(road,year,asset_type)
% loop through images and annotate the assets.

% loading text file to write to.
file_name = sprintf('%s_%s_Annotations.txt',road,year);
file = fullfile('C:','Users','ts1454','CH2M','Code','Python','Object Detection',file_name);
fileID = fopen(file,'w');

% loading images, asset data, nav data and camera parameters
image_dir = fullfile(dataDir,road,year,'images');
images = dir(fullfile(image_dir,'2*.jpg')); 
nav_file = readtable(fullfile(dataDir,road,year,'Nav','Nav.csv'));

asset_dbf_folder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');   
asset_dbf_files = dir(fullfile(asset_dbf_folder,['*',asset_type,'*.dbf']));
asset_dbf_file = asset_dbf_files(1);
[asset_data, field_names] = dbfRead(fullfile(asset_dbf_folder,asset_dbf_file.name));
asset_data_table = cell2table(asset_data,'VariableNames',field_names);

camera_params = cameraConfig();


%% finding assets in the images
num_images = size(images,1);
% shuffling images for fun
images = images(randperm(length(images)),:);
for i = 1:num_images
    fprintf('%d out of %d images processed\n',i,num_images)
    image = images(i);
    image_file_name = image.name;
    image_nav = getNavFromFile(image_file_name,nav_file);
    % find assets
    [assets, Pcs] = findAssetsInImage(asset_data_table, image_nav, 5, 60, 10, year, camera_params);
    % assets = n * [u,v,u_box,v_box,w_box,h_box]
           
    if size(assets,1) > 0 && any(Pcs(:,2) < 30) && image_nav.ALT < 14
        label = sprintf('%s\\%s',image_dir,image_file_name);
        pixels = assets(:,1:2);
        boxes = assets(:,3:6);      
        img = imread(fullfile(image_dir,image_file_name));
        imshow(img)
        hold on
        % plotting original assets
%         num_assets = size(assets,1);
%         for asset_num = 1:num_assets
%             
%             rectangle('Position',boxes(asset_num,:),'LineWidth',1,'LineStyle','-', ...
%                       'EdgeColor','r','Curvature',0);
%             plot(pixels(asset_num,1), pixels(asset_num,2), 'g+')
%             text(pixels(asset_num,1), pixels(asset_num,2),...
%                  asset_type,'color','m')
%         end
        
        % plotting merged boxes
        merged_boxes = mergeBoxes(boxes,0.2);
        num_merged_boxes = size(merged_boxes,1);
        for box_num = 1:num_merged_boxes
            box = merged_boxes(box_num,:);
            label = strcat([label,...
                sprintf(' %d,%d,%d,%d,%s ',box(1),box(2),box(3),box(4),'0')]);
                
            rectangle('Position',box,'LineWidth',2,'LineStyle','--',...
                'EdgeColor','g','Curvature',0);
        end
        label
        fprintf(fileID,'%s\r\n',label);
        hold off
    end
    
end
fclose(fileID);

