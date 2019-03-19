function [image,boxClosest,targetPixels] = findClosestImage(navFile,asset,camera,assetDimensions,assetZ,cameraParams)
%getClosestImage Gets closest image taken of the asset.
%
%   INPUTS:
%       navFile: Navigation file containing all image metadata [(nImages,nCols) TABLE].
%       asset: Row from the asset data table [(1,nCols), TABLE].
%       camera: Camera number {1,2,3,4} [INT].
%       assetDimensions: Asset length, width and height [(1,3) ARRAY].
%       assetZ: Z coordinate of asset relative the camera [INT].
%       cameraParams: Parameters of calibrated camera [STRUCT].
%   OUTPUTS:
%       image: Metadata of closest image taken of the asset [(1,nCols) TABLE].
%       box: Bounding box of the asset in the closest image [(1,4) ARRAY].
%       targetPixels: Pixels of the asset in the closest image [(1,2) ARRAY].

BUFFER = 50; % asset must be this many pixels away from image edge.
% only consider images this far away from the asset
MIN_X = 10;
MAX_X = 50;
MAX_Y = 20;

% firstly only consider photos within a certain x distance away
distances = sqrt((navFile.XCOORD - asset.XCOORD).^2 + (navFile.YCOORD - asset.YCOORD).^2);
navFile = navFile(distances < MAX_X,...
                   {'XCOORD','YCOORD','HEADING','PCDATE','PCTIME',...
                   'PITCH','ROLL','YAW'});
            
%% loop through images in nav files and get the position of asset in the frame of the camera, box and pixels of the asset with respect to each image
nNavFiles = size(navFile,1);
pVehicles = [];
boxes = [];
pixels = [];

for iNavFile = 1:nNavFiles
    image = navFile(iNavFile,:);
    % relative position of asset and camera
    pAssetWorld = [asset.XCOORD,asset.YCOORD,assetZ]';
    pVehicleWorld = [image.XCOORD,image.YCOORD,0]';
    pWorld = pAssetWorld-pVehicleWorld;
    % % converting the camera frame of reference
    pan = navFile(iNavFile,{'HEADING'}).HEADING;
    %tilt = navFile(iNavFile,{'PITCH'}).PITCH; roll = navFile(iNavFile,{'ROLL'}).ROLL;
    %Pc = toCameraCoords(W,pan,tilt,roll);
    pVehicle = toVehicleCoords(pWorld,pan,0,0);
    box = getBoundingBox(pVehicle,assetDimensions,cameraParams);
    pVehicles = [pVehicles; pVehicle'];
    boxes = [boxes; box];
    [u,v] = getPixelsFromCoords(pVehicle,cameraParams);
    pixels = [pixels; u,v];
end
%% find assets that are actually in the image and are within MIN_X, MAX_X and MAX_Y.
% getting assets with x between MIN_X and MAX_X
correctX = pVehicles(:,1) > MIN_X & pVehicles(:,1) < MAX_X;
pVehicles = pVehicles(correctX,:);
boxes = boxes(correctX,:);
pixels = pixels(correctX,:);
navFile = navFile(correctX,:);

% getting assets with y less than MAX_Y
correctY = abs(pVehicles(:,2)) < MAX_Y;
pVehicles = pVehicles(correctY,:);
boxes = boxes(correctY,:);
pixels = pixels(correctY,:);
navFile = navFile(correctY,:);

% are pixels in the image (plus a buffer)
correctPixels = pixels(:,1) < cameraParams.m - BUFFER & pixels(:,1) > BUFFER ...
    & pixels(:,2) < cameraParams.n - BUFFER & pixels(:,2) > BUFFER;
pVehicles = pVehicles(correctPixels,:);
boxes = boxes(correctPixels,:);
pixels = pixels(correctPixels,:);
navFile = navFile(correctPixels,:);

% are boxes in the image
correctBoxes = boxes(:,1) > 0 & boxes(:,1) + boxes(:,3) < cameraParams.m ... 
            & boxes(:,2) > 0 & boxes(:,2) + boxes(:,4) < cameraParams.n;
% if not, allow boxes that are no completely contained in the image
if sum(correctBoxes) > 0
    navFile = navFile(correctBoxes,:);
    pVehicles = pVehicles(correctBoxes,:);
    boxes = boxes(correctBoxes,:);
    pixels = pixels(correctBoxes,:);
end

%% find closest image
distances = sqrt(pVehicles(:,1).^2 + pVehicles(:,2).^2 + pVehicles(:,3).^2);
minInd = find(distances==min(distances));
navFile = navFile(minInd,:);
pCameraClosest = pVehicles(minInd,:);
boxClosest = boxes(minInd,:);
pixelsClosest = pixels(minInd,:);

% get find name
fileName = char(strcat([num2str(num2str(camera)),...
                 '_',...
                 num2str(navFile.PCDATE),...
                 '_',...
                 num2str(navFile.PCTIME),...
                 '.jpg']));
             
% if a closest image exists
if size(pCameraClosest) > 0
    % define heading northing and easting and angles
    Heading = navFile.HEADING;
    Northing = navFile.XCOORD;
    Easting = navFile.YCOORD;
    Tilt = navFile.PITCH;
    Roll = navFile.ROLL;
    image = table({fileName},Easting,Northing,Heading,Tilt,Roll,pCameraClosest(1),pCameraClosest(2),pCameraClosest(3),...
                    'VariableNames',{'fileName','Easting','Northing','Heading','Tilt','Roll','assetX','assetY','assetZ'});
    targetPixels = pixelsClosest;
else
    image = [];
    boxClosest = [];
    targetPixels = [];
end
end