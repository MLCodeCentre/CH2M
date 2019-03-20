function orderAssets

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
for iImage = 1:nImages
    fprintf('searched through %d of %d images, found %d asssets\n',iImage,nImages,size(assetList,1)-1);
    
    image = navFile(iImage,:);
    [~, pVehicles, assetInfo] = findAssetsInImage(assetDataTable,image,cameraParams(year));
    
    assets = [pVehicles,assetInfo.XCOORD, assetInfo.YCOORD, assetInfo.MOUNTING_H];
    assets = sortrows(assets,1);
    
    nAssets = size(assets,1);
    for iAsset = 1:nAssets
        assetLeft = pVehicles(iAsset,2) < 0;
        assetXcoord = assetInfo(iAsset,:).XCOORD;
        assetYcoord = assetInfo(iAsset,:).YCOORD;
        assetMountingH = assetInfo(iAsset,:).MOUNTING_H;
        assetEntry = [assetLeft,assetXcoord,assetYcoord,assetMountingH];
        if ~any(assetXcoord == assetList(:,2) & assetYcoord == assetList(:,3) & assetMountingH == assetList(:,4))
            assetList = [assetList;assetEntry];
        end
    end
end

save('assetList','assetList');