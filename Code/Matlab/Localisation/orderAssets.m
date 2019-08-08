function orderAssets
close all
% ordering asset of type as they are driven past.
road = 'A27'; year = 'Year2';

% loading assets
assetType = 'SNSF';
assetDbfFolder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');   
assetDbfFiles = dir(fullfile(assetDbfFolder,['*',assetType,'*.dbf']));
assetDbfFile = assetDbfFiles(1);
[assetData, fieldNames] = dbfRead(fullfile(assetDbfFolder,assetDbfFile.name));
assetDataTable = cell2table(assetData,'VariableNames',fieldNames);

% loading camera parameters
cameraParams = setCameraParams(dataDir,road);

navFile = readtable(fullfile(dataDir,road,year,'Nav','Nav.csv'));
% order so it's as we drive
navFile = sortrows(navFile,{'PCDATE','PCTIME'});

% loop through assets and find all sign posts
assetList = [0,0,0,0];

nImages = size(navFile,1);
for iImage = 1239:5:nImages
    fprintf('searched through %d of %d images, found %d asssets\n',iImage,nImages,size(assetList,1)-1);
    
    image = navFile(iImage,:);
    [assetInfo, pVehicles, assets] = findAssetsInImage(assetDataTable,image,cameraParams(year));
    
    assetGeoPixelBox = [pVehicles,assets.XCOORD,assets.YCOORD,assets.MOUNTING_H,assetInfo];
    assetGeoPixelBox = sortrows(assetGeoPixelBox,1);
    
    nAssets = size(assetGeoPixelBox,1);
    
    if nAssets > 0
        imageFile = constructFileName(2,image.PCDATE,image.PCTIME);
        img = imread(fullfile(dataDir,road,year,'Images',imageFile));
        for iAsset = 1:nAssets        
            assetLeft = assetGeoPixelBox(iAsset,2) < 0;
            assetXCOORD = assetGeoPixelBox(iAsset,4);
            assetYCOORD = assetGeoPixelBox(iAsset,5);
            assetMountingH = assetGeoPixelBox(iAsset,6);
            assetEntry = [assetLeft,assetXCOORD,assetYCOORD,assetMountingH];
            if newAsset(assetXCOORD,assetYCOORD,assetMountingH,assetList,0.5)
                assets(iAsset,:);
                assetList = [assetList;assetEntry];
                imshow(img);
                hold on
                plotAssetOnImage(assetGeoPixelBox(iAsset,:),iAsset);
                %input('next')
            end
        end
        hold off
    end
    
    
end

% removing intial line 
assetList(1,:) = [];
%save('assetList','assetList');
end

function new = newAsset(assetXCOORD,assetYCOORD,assetMountingH,assetList,threshold)
    sameXCOORD = any(abs(assetXCOORD - assetList(:,2)) < threshold);
    sameYCOORD = any(abs(assetYCOORD - assetList(:,3)) < threshold);
    sameHeight = any(abs(assetMountingH - assetList(:,4)) < threshold);
    notNew = sameXCOORD & sameYCOORD & sameHeight;
    new = ~notNew;
end

function plotAssetOnImage(asset,iAsset)
box = asset(end-3:end);
rectangle('Position',box,'EdgeColor','r');
%text(asset(end-5),asset(end-4),num2str(iAsset));

end

function fileName = constructFileName(camera,PCDATE,PCTIME)
fileName = sprintf('%d_%d_%d.jpg',camera,PCDATE,PCTIME);
end
