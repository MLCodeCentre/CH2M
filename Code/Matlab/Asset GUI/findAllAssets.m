function [assetsImage,assetTypesImage] = findAllAssets(image,assetTypes,dataDir,cameraParams)
%findAllAssets Finds all assets of all types in "assetTypes" in the image
%
%   INPUTS:
%       image: Image metadata [(1,nCols) TABLE].
%       assetTypes: Asset types to plot [(nAssets,1) CELL].
%       dataDir: Top level directory where data is stored [CHAR].
%       road: Road being analysed [CHAR].
%       cameraParams: Parameters of calibrated camera [STRUCT].
%   OUTPUTS:
%       assetsImage: Assets found in image [(nAssets,nCols) TABLE].
%       assetTypesImage: Asset types found in image [(nAssets,nCols) TABLE].

assetsImage = [];
assetTypesImage = [];
%% looping through asset types
assetTypes = assetTypes(~cellfun('isempty',assetTypes));
nAssetTypes = numel(assetTypes);

for iAssetType = 1:nAssetTypes  
    % parsing asset code
    assetType = assetTypes{iAssetType};
    assetTypeInfo = strsplit(assetType,' ');
    assetType = assetTypeInfo{1};
    
    % loading data and looping through
    assetDbfFolder = fullfile(dataDir,'Inventory');   
    assetDbfFiles = dir(fullfile(assetDbfFolder,['*',assetType,'*.dbf']));
    
    if isempty(assetDbfFiles) == 0
        
        assetDbfFile = assetDbfFiles(1);
        [assetData,fieldNames] = dbfRead(fullfile(assetDbfFolder,assetDbfFile.name));
        assetDataTable = cell2table(assetData,'VariableNames',fieldNames);
        % if there is any location information get assets in image and
        % append to lists
        if any(strcmp('XCOORD',fieldNames))  
            
            assets = findAssetsInImage(assetDataTable,image,cameraParams);
            nAssetsImage = size(assets,1);
            for iAsset = 1:nAssetsImage
                assetsImage = [assetsImage; assets(iAsset,:)];
                assetTypesImage = [assetTypesImage; assetType];
            end
        end
    end
end