function [assetsImage1,assetTypesImage1,assetsImage2,assetTypesImage2] = ...
    findAllAssets(image1,image2,assetTypes,dataDir,road,cameraParams)
% Finds all assets by looping through all asset types, loading the asset data and calling
% findAssetsInImage.

% setting variables and lists
MIN_X = 7;
MAX_X = 40;
MAX_Y = 30;

assetsImage1 = [];
assetsImage2 = [];
assetTypesImage1 = [];
assetTypesImage2 = [];

%% looping through asset types
assetTypes = assetTypes(~cellfun('isempty',assetTypes));
nAssetTypes = numel(assetTypes);

for iAssetType = 1:nAssetTypes  
    % parsing asset code
    assetType = assetTypes{iAssetType};
    assetTypeInfo = strsplit(assetType,' ');
    assetType = assetTypeInfo{1};
    
    % loading data and looping through
    assetDbfFolder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');   
    assetDbfFiles = dir(fullfile(assetDbfFolder,['*',assetType,'*.dbf']));
    
    if isempty(assetDbfFiles) == 0
      
        assetDbfFile = assetDbfFiles(1);
        [assetData,fieldNames] = dbfRead(fullfile(assetDbfFolder,assetDbfFile.name));
        assetDataTable = cell2table(asset_data,'VariableNames',fieldNames);
        % if there is any location information get assets in image and
        % append to lists
        if any(strcmp('XCOORD',fieldNames))
        
            assets = findAssetsInImage(assetDataTable,image1,MIN_X,MAX_X,MAX_Y,'Year1',cameraParams);
            nAssetsImage1 = size(assets,1);
            for iAsset = 1:nAssetsImage1
                assetsImage1 = [assetsImage1; assets(iAsset,:)];
                assetTypesImage1 = [assetTypesImage1; assetType];
            end
            
            assets = findAssetsInImage(assetDataTable,image2,MIN_X,MAX_X,MAX_Y,'Year2',cameraParams);
            nAssetsImage2 = size(assets,1);
            for iAsset = 1:nAssetsImage2
                assetsImage2 = [assetsImage2; assets(iAsset,:)];
                assetTypesImage2 = [assetTypesImage2; assetType];
            end
        end
    end
end





