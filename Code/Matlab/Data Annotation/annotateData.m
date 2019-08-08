function annotateData(road,assetType,navFile)
%ANNOTATEDATA Create data to retrain yolo network with i.e bounding box
% and class.

% annotated images will be saved here:
imageSaveDir = fullfile('C:','Jacobs','Object Detection',sprintf('%s_%s',road,assetType));
mkdir(imageSaveDir);

% for python implementation of yolo:

%% loading survey data
% images
imageDir = fullfile(dataDir,road,'Images');
images = dir(fullfile(imageDir,'2*.jpg')); % 2 gets forward facing imagery only
% camera parameters
cameraParams = table2struct(readtable(fullfile(dataDir,road,'Calibration',...
    'camera_parameters.csv')));
% assets
assetDir = fullfile(dataDir,road,'Inventory');
assetFiles = dir(fullfile(assetDir,sprintf('*%s*.dbf',assetType)));
assetFile = assetFiles(1);
[assetData, fieldNames] = dbfRead(fullfile(assetDir,assetFile.name));
assetData = cell2table(assetData,'VariableNames',fieldNames);
% nav file - if empty
if isempty(navFile)
    navFile = loadNavFile(road); 
end

% creating annotation table columns
imageFileName = {};
assetBoxes = {};
show = false;
%% finding assets in the images
nImages = size(images,1);
%nImages = 50;
% shuffling images for fun
%images = images(randperm(nImages),:);
for iImage = 1:nImages
    %fprintf('%d out of %d images processed\n',iImage,nImages)
    % load image
    image = images(iImage);
    imageName = image.name;
    imageNav = getNavFromFile(imageName,navFile);
    % find assets
    [assets, Pcs] = findAssetsInImage(assetData,imageNav,cameraParams);
    % assets = n * [u,v,u_box,v_box,w_box,h_box]           
    if size(assets,1) > 0
        fprintf('%d images in training set (%d/%d images)\n',...
            size(imageFileName,1),iImage,nImages)
        pixels = assets(:,1:2);
        boxes = assets(:,3:6);       
        if show
            img = imread(fullfile(imageDir,imageName));
            imshow(img)
            hold on
            % plotting assets
            nAssets = size(assets,1);
            for iAsset = 1:nAssets           
                rectangle('Position',boxes(iAsset,:),'LineWidth',1,'LineStyle','-', ...
                          'EdgeColor','r','Curvature',0);
                plot(pixels(iAsset,1), pixels(iAsset,2), 'g+')
                text(pixels(iAsset,1), pixels(iAsset,2),...
                     assetType,'color','m')
            end
        end
        % add to data
        imageFileName{end+1,1} = imageName;
        assetBoxes{end+1,1} = boxes;
        nBoxes = size(boxes,1);
        % copy image to other directory
        copyfile(fullfile(imageDir,imageName),fullfile(imageSaveDir,imageName))
        % create a training label for the image
        imageInfo = split(imageName,'.');
        imageNameNoExt = imageInfo{1};
        fileID = fopen(fullfile(imageSaveDir,sprintf('%s.txt',imageNameNoExt)),'w');
        imgWidth = 2560; imgHeight = 2048;
        for iBox = 1:nBoxes
            yoloX = boxes(iBox,1)/imgWidth; yoloY = boxes(iBox,2)/imgHeight;
            yoloW = boxes(iBox,3)/imgWidth; yoloH = boxes(iBox,4)/imgHeight;
            fprintf(fileID,'%d %1.8f %1.8f %1.8f %1.8f\n',0,yoloX,yoloY,yoloW,yoloH);
        end
        fclose(fileID);
    end   
end
% write table
yoloTrainingTable = table(imageFileName,assetBoxes);
yoloTrainingTable.Properties.VariableNames = {'imageFileName',assetType};
save(fullfile(rootDir,'Data Annotation','Annotations',...
    sprintf('%s_%s_yolo.mat',road,assetType)),'yoloTrainingTable')