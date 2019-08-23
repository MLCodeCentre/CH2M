function box = getBoundingBox(assetPosition,assetDimensions,cameraParams)
%getBoundingBox Calculates the bounding box of an asset in an image given its relative the camera and dimensions.
%
%   INPUTS:
%       assetPosition: Position vector of asset relative the camera [(1,3) ARRAY].
%       assetDimensions: Asset length, width and height [(1,3) ARRAY].
%   OUTPUTS:
%       box: Bounding box around image [(1,4) ARRAY].

% if width and height aren't provided then 1m for each is assumed. 
% allow a small error buffer for asset X,Y and Z.
BUFFER = 0.1;
BUFFER_Z = 0.1;

% unpack asset Position and Dimensions
assetX = assetPosition(1); assetY = assetPosition(2); assetZ = assetPosition(3);
assetLength = assetDimensions(1); assetWidth = assetDimensions(2);
assetHeight = assetDimensions(3);

% calculate the ranges of x,y,z given the asset dimensions
rangeX = [max(0,assetX - (assetLength / 2) - 0*BUFFER),assetX + (assetLength / 2) + 0*BUFFER];
rangeY = [assetY - (assetWidth / 2) - BUFFER, assetY + (assetWidth / 2) + BUFFER];
rangeZ = [assetZ - BUFFER_Z, assetZ + assetHeight + 2*BUFFER];
%rangeZ = [0,assetZ + assetHeight + BUFFER_Z];%
% find corresponding pixels
U = [];
V = [];
for iX = rangeX
    for iY = rangeY
        for iZ = rangeZ
            [u,v] = getPixelsFromCoords([iX,iY,iZ]',cameraParams);
            U = [U,u]; V = [V,v];
        end
    end
end

% find box from max and min pixels and make sure box is in image. 
minU = max(0,ceil(min(U)));
maxU = min(ceil(max(U)),cameraParams.m);
minV = max(0,ceil(min(V)));
maxV = min(ceil(max(V)),cameraParams.n);

% format to [u,v,w,h]
boxX = minU; boxW = maxU - minU;
boxY = minV; boxH = maxV - minV;

box = [boxX,boxY,boxW,boxH];