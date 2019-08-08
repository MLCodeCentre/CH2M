function [assets,pVehicles,assetDimensions] = findCloseAssets(assets,image)

MIN_X = 5;
MAX_X = 80;
MAX_Y = 20;

% Initial filter to get only assets near to the photo
assetLocation = [assets.XCOORD,assets.YCOORD,zeros(size(assets.YCOORD))];
imageLocation = [image.XCOORD,image.YCOORD,0];

assetRelativeLocation = bsxfun(@minus,assetLocation,imageLocation);
assetDistance = sqrt((assetRelativeLocation(:,1).^2 + assetRelativeLocation(:,2).^2));
nearbyAssets = assets(assetDistance<300,:);

numAssets = size(nearbyAssets,1);
pVehicles = []; % Position vectors of assets in the frame of the camera
assetDimensions = [];
% Loop through assets and get, Pc, box and pixels of the asset with respect
% to the image
for iAsset = 1:numAssets
    asset = nearbyAssets(iAsset,:);
    % asset and vehicle position in the world
    [assetDimension,assetZ] = getAssetDimensions(asset);
    pAssetWorld = [asset.XCOORD,asset.YCOORD,assetZ]';
    pVehicleWorld = [image.XCOORD,image.YCOORD,0]';
    pWorld = pAssetWorld-pVehicleWorld; % relative position in the world
    % converting the vehicle frame of reference
    pan = image.HEADING;
    pVehicle = toVehicleCoords(pWorld,pan,0,0);
    % get bounding box and pixels
    pVehicles = [pVehicles;pVehicle'];
    assetDimensions = [assetDimensions;assetDimension];
end

%% find assets that are actually in the image and are within MIN_X, MAX_X and MAX_Y.
% getting assets with x between MIN_X and MAX_X
if size(pVehicles,1)>0
    correctX = pVehicles(:,1) > MIN_X & pVehicles(:,1) < MAX_X;    
    % getting assets with y less than MAX_Y
    correctY = abs(pVehicles(:,2)) < MAX_Y;
    pVehicles = pVehicles(correctX&correctY,:);
    assetDimensions = assetDimensions(correctX&correctY,:);
    assets = nearbyAssets(correctX&correctY,:);
else
    assets = [];
end
 
end