function assets = findAssetsInImage(assets,image,cameraParams)
% findAssetsInImage Find all assets in the table "assets" that are the in the image.
%
%   INPUTS:
%       assets: Assets to search for in the image [(nAssets,nCols) TABLE].
%       image: Image metadata [(1,nCols) TABLE].
%       cameraParams: Parameters of calibrated cameras [STRUCT].
%   OUTPUTS:
%       assets: Assets found in the image [(nAssets, nCols) TABLE].
%       pCameras: The position vector of the assets relative to the camera [(nAssets,3) ARRAY]

% only consider images this far away from the asset
MIN_X = 7;
MAX_X = 50;
MAX_Y = 40;
BUFFER = 50; % Assets must be this many pixels within the image

% Initial filter to get only assets near to the photo
assetLocation = [assets.XCOORD,assets.YCOORD,zeros(size(assets.YCOORD))];
imageLocation = [image.Northing,image.Easting,0];

assetRelativeLocation = bsxfun(@minus,assetLocation,imageLocation);
assetDistance = sqrt((assetRelativeLocation(:,1).^2 + assetRelativeLocation(:,2).^2));
nearbyAssets = assets(assetDistance<100,:);

numAssets = size(nearbyAssets,1);
pVehicles = []; % Position vectors of assets in the frame of the camera
boxes = []; % Bounding boxes around assets
pixels = []; % Pixels of assets

% Loop through assets and get, Pc, box and pixels of the asset with respect
% to the image
for iAsset = 1:numAssets
    asset = nearbyAssets(iAsset,:);
    [assetDimensions,assetZ] = getAssetDimensions(asset);
    
    % asset and vehicle position in the world
    pAssetWorld = [asset.XCOORD,asset.YCOORD,assetZ]';
    pVehicleWorld = [image.Northing,image.Easting,0]';
    pWorld = pAssetWorld-pVehicleWorld; % relative position in the world
    % converting the vehicle frame of reference
    pan = image.Heading;
    pVehicle = toVehicleCoords(pWorld,pan,0,0);
    % get bounding box and pixels
    box = getBoundingBox(pVehicle,assetDimensions,cameraParams);
    pVehicles = [pVehicles; pVehicle'];
    boxes = [boxes; box];
    [u,v] = getPixelsFromCoords(pVehicle,cameraParams);
    pixels = [pixels; u,v];
end

%% find assets that are actually in the image and are within MIN_X, MAX_X and MAX_Y.
if size(pVehicles,1) > 0
    % getting assets with x between MIN_X and MAX_X
    correctX = pVehicles(:,1) > MIN_X & pVehicles(:,1) < MAX_X;
    pVehicles = pVehicles(correctX,:);
    boxes = boxes(correctX,:);
    pixels = pixels(correctX,:);

    % getting assets with y less than MAX_Y
    correctY = abs(pVehicles(:,2)) < MAX_Y;
    pVehicles = pVehicles(correctY,:);
    boxes = boxes(correctY,:);
    pixels = pixels(correctY,:);

    % are pixels in picture plus a buffer
    correctPixels = pixels(:,1) < cameraParams.m - BUFFER & pixels(:,1) > BUFFER ...
        & pixels(:,2) < cameraParams.n - BUFFER & pixels(:,2) > BUFFER;
    pVehicles = pVehicles(correctPixels,:);
    boxes = boxes(correctPixels,:);
    pixels = pixels(correctPixels,:);
end
% return pixels and bounding boxes of assets
assets = [pixels,boxes];