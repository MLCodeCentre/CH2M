function [closestAsset,assetPixels,assetBox] = findClosestAsset(assets,image,u,v,cameraParams)
%findClosestAsset Finds closest asset to the pixels u,v.
%
%   INPUTS:
%       assets: Table of assets [(nAssets,nCols) TABLE].
%       image: Image metadata [(1,nCols) TABLE].
%       u,v: Pixel pairs [INT].
%       cameraParams: Parameters of calibrated camera [STRUCT].
%   OUTPUTS:
%       closestAsset: Row from assets that represents the closest asset to u,v [(1,nCols) TABLE].
%       assetPixels: Pixel pair of the asset in the closest asset in the image [(1,2) ARRAY].
%       assetBox: Bounding box of the closest asset in the image in the form [u,v,w,h] [(1,4) ARRAY].

% consider only assets that are this far away and a maximum number of
% pixels away from the click
MIN_X = 0;
MAX_X = 100; 
MAX_Y = 40;
MAX_PIXELS = 250;

nAssets = size(assets,1);
for iAsset = 1:nAssets
    asset = assets(iAsset,:);
    % get asset height
    [assetDimensions(iAsset,:),assetZ(iAsset,1)] = getAssetDimensions(asset); 
    % asset and camera position in the world
    pAssetWorld = [asset.XCOORD,asset.YCOORD,assetZ(iAsset,1)]';
    pVehicleWorld = [image.XCOORD,image.YCOORD,0]';
    pWorld = pAssetWorld-pVehicleWorld; % relative position in the world
    % converting to the vehicle frame of reference
    pan = image.HEADING;
    %tilt = image.Tilt; roll = image.Roll;
    pVehicle = toVehicleCoords(pWorld,pan,0,0);
    assetPosition(iAsset,:) = [pVehicle(1), pVehicle(2), assetZ(iAsset,1)];

    % now calculate pixels this asset would be in in the image. 
    [assetU(iAsset,1),assetV(iAsset,1)] = ...
        getPixelsFromCoords(pVehicle,cameraParams);
    % calculate euclidean distance of the pixels
    pixelDistance(iAsset,1) = sqrt((u-assetU(iAsset,1)).^2 + (v-assetV(iAsset,1)).^2);
end

%% now find the closest asset the click
assetTable =[assets,table(assetPosition,assetU,assetV,assetDimensions,pixelDistance)];
% filter out negative xs and big ys and large pixel distances
assetTable = assetTable(assetTable.assetPosition(:,1) > MIN_X & assetTable.assetPosition(:,1) < MAX_X,:);
assetTable = assetTable(abs(assetTable.assetPosition(:,2)) < MAX_Y,:);
assetTable = assetTable(assetTable.pixelDistance < MAX_PIXELS,:);

% now find closest remaining asset
closestAsset = assetTable(assetTable.pixelDistance == min(assetTable.pixelDistance(:)),:);

% pixels
assetPixels = [closestAsset.assetU, closestAsset.assetV];
% get bounding box
if isempty(closestAsset)
    assetBox = [];
else
    assetBox = getBoundingBox(closestAsset.assetPosition,...
        closestAsset.assetDimensions,cameraParams);
end

% delete extra info
closestAsset.assetPosition = [];
closestAsset.assetDimensions = [];
closestAsset.pixelDistance = [];