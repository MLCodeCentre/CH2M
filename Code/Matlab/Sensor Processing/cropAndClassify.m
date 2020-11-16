function accuracy = cropAndClassify(assets,navFile,road,imgSet,show_plot)
%cropAndClassify crops assets out of a series of images in navFile and
%classifies. The idea is, that the navFile that is correctly
%preprocessed will result in a correct classification all the time.
%Therefore, the optimal kalman filter parameters can be found. 

%navFile = navFile(6:end,:);
nNav = size(navFile,1);
% track each asset around a corner. 
whiteRatio = []; % classifcation labels stored here. 
cameraParams = loadCameraParams(road);% loading camera params to crop asset out of images
for iNav = 1:nNav
    ydist = [];
    if show_plot
        figure;
    end
    %fprintf('%d/%d\n',iAsset,nAssets)
    image = navFile(iNav,:);
    [assetsImage,pVehicles] = findAssetsInImage(assets,image,cameraParams);
    %figure;
    % select image from navFile and find asset
    % crop image    
    nAssets = size(assetsImage,1);
    for iAsset = 1:nAssets
        box = assetsImage(iAsset,3:6);
        img = imgSet{iNav};
        assetCrop = imcrop(img,box);
        if show_plot
            imshow(assetCrop);
        end
        assetCropFlat = assetCrop(:);
        % NEW PLAN MOST WHITE IN CROP THIS WILL SPEED THINGS UP!
        %imshow(assetCrop)
        whiteRatio(end+1) = sum(assetCropFlat > 200)/numel(assetCropFlat);
    end
end
accuracy = mean(whiteRatio);
end