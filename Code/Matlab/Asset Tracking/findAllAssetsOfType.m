function [assetsImage1,assetsImage2] = findAllAssetsOfType(image1,image2,assetDataTable,cameraParams)

MIN_X = 7;
MAX_X = 40;
MAX_Y = 20;

assetsImage1 = [];
assetsImage2 = [];

assets = findAssetsInImage(assetDataTable,image1,MIN_X,MAX_X,MAX_Y,'Year1',cameraParams);
nAssetsImage1 = size(assets,1);

for iAsset = 1:nAssetsImage1
    assetsImage1 = [assetsImage1; assets(iAsset,:)];
end

assets = findAssetsInImage(assetDataTable,image2,MIN_X,MAX_X,MAX_Y,'Year2',cameraParams);
nAssetsImage2 = size(assets,1);
for iAsset = 1:nAssetsImage2
    assetsImage2 = [assetsImage2; assets(iAsset,:)];
end
