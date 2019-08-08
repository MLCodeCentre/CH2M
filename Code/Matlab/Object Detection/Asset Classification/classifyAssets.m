function uncheckedAssets = classifyAssets(road,year,assetType,net)

% loading images, asset data, nav data and camera parameters
imageDir = fullfile('F:',year,road,'images');
%images = dir(fullfile(imageDir,'2*.jpg')); 
navFile = loadNavFile(fullfile('F:',year,road,'Nav'),road);

% loading the test assets
assetsTestLoad = load(fullfile('Assets_Test',sprintf('%s_assetsTest.mat',assetType)));
assets = assetsTestLoad.assetsTest;
nAssets = size(assets,1);
uncheckedAssets = [];

% loading camera parameters
cameraParamTable = readtable(fullfile(dataDir,road,year,'calibration_parameters.csv'));
cameraParams = table2struct(cameraParamTable);

% labels for each of the prediction indices.
labels = {'MKRF','Random','SGMA','SNSF'};
cols = {'g','k','r','b'};
% initialise results matrix nAssets nVerifications nNoImage
results = zeros(1,2,3);

% results print out 
disp('+----------------------------------------------------------------+')
disp('+---nAssets---|---Verifications---|---Percentage---|---No Image--+')
for iAsset = 1:nAssets
    % calculate asset dimensions, and identify it in the nearest image
   [assetDimensions,assetZ] = getAssetDimensions(assets(iAsset,:));
   [image,boxClosest,targetPixels] = findClosestImage(navFile,assets(iAsset,:),2,assetDimensions,assetZ,cameraParams);
   if ~isempty(image)
       % an image was found:
       results(1,1) = results(1,1) + 1;
       % load image and crop asset
       img = imread(fullfile(imageDir,image.fileName{1}));
       assetCrop = imcrop(img,boxClosest);
       % classify the asset
       preds = predict(net,imresize(assetCrop,[224,224]));
       iMaxPred = preds==max(preds);
       label = labels{iMaxPred};
       % if incorrect classification
       if ~strcmpi(label,assetType)
           uncheckedAssets = [uncheckedAssets;assets(iAsset,:)];
           imshow(img); hold on
           rectangle('Position',boxClosest,'EdgeColor','r','LineWidth',3)
           input('Press any key for next incorrect classification')
       else
           % update correct classification
           results(1,2) = results(1,2) + 1;
%            imshow(img); hold on
%            rectangle('Position',boxClosest,'EdgeColor','g','LineWidth',3)
%            input('Press any key for next correct classification')
       end
   else
       % update that there was no image taken
       results(1,3) = results(1,3) + 1;
       uncheckedAssets = [uncheckedAssets;assets(iAsset,:)];
   end
   fprintf('|     %3d     |        %3d        |      %0.2f      |     %3d     |\n',...
       results(1,1),results(1,2),results(1,2)/results(1,1),results(1,3))
end
disp('+----------------------------------------------------------------+')