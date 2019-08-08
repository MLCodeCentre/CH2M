function createPaperImage(net)
close all
% loading all test images. 

% loading nav of file
PCDATE = 2369; PCTIME = 1680;
imageFile = sprintf('2_%d_%d.jpg',PCDATE,PCTIME);
imageNav = navFile(navFile.PCDATE==PCDATE & navFile.PCTIME==PCTIME,:);

% cropping assets with calibrated camera. 
road = 'A27'; year = 'Year2';
cameraParamTable = readtable(fullfile(dataDir(),year,road,'calibration_parameters.csv'));
cameraParams = table2struct(cameraParamTable);

assetTypes = {'SNSF','MKRF','SGMA'};
assetTypes = {'SNSF'};
[assetsImage,assetTypesImage] = findAllAssets(imageNav,assetTypes,dataDir(),road,cameraParams);
img = imread(fullfile('F:',year,road,'Images',imageFile));

%% classifying
nAssets = size(assetsImage,1)
labels = {'MKRF','Random','SGMA','SNSF'};
for iAsset = 1:nAssets
    box = assetsImage(iAsset,3:6);
    assetCrop = imcrop(img,box);
    preds = predict(net,imresize(assetCrop,[224,224]));
    iMaxPred = preds==max(preds);
    label = labels{iMaxPred};
    classificationLabel{iAsset} = label;
end

%% plotting results
imshow(img);
hold on

plotAllAssets(assetsImage,assetTypesImage,classificationLabel,true,'m')

% imageNav.HEADING = imageNav.HEADINGOLD;
% [assetsImage,assetTypesImage] = findAllAssets(imageNav,assetTypes,dataDir(),road,cameraParams);
% img = imread(fullfile('F:',year,road,'Images',imageFile));
% 
% %% classifying
% nAssets = size(assetsImage,1)
% labels = {'MKRF','Random','SGMA','SNSF'};
% for iAsset = 1:nAssets
%     box = assetsImage(iAsset,3:6);
%     assetCrop = imcrop(img,box);
%     preds = predict(net,imresize(assetCrop,[224,224]));
%     iMaxPred = preds==max(preds);
%     label = labels{iMaxPred};
%     classificationLabel{iAsset} = label;
% end
% hold on
% plotAllAssets(assetsImage,assetTypesImage,classificationLabel,true,'g')

end

function plotAllAssets(assetsImage,assetTypesImage,classificationLabel,plotBox,col)
% plots all assets, to hide the bounding box set plotBox to False, otherwise True.  
nAssets = size(assetsImage,1);
hold on
for iAsset = 1:nAssets
    % parse the columns of assetsImage
    uAsset = assetsImage(iAsset,1);
    vAsset = assetsImage(iAsset,2);
    box = assetsImage(iAsset,3:6);
    % plot bounding box if requested
    if plotBox
        if strcmpi(classificationLabel{iAsset},assetTypesImage(iAsset,:))
            colour = col;
        else
            colour = col;
        end
         rectangle('Position',box,'LineWidth',3,'LineStyle','-',...
               'EdgeColor',colour,'Curvature',0);      
    end
    % plot pixels
    %plot(uAsset,vAsset,'g+')
    %text(uAsset,vAsset,assetTypesImage(iAsset,:),'color','m')
end
hold off
end