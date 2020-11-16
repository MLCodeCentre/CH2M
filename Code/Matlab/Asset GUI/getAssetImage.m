function [image,box,targetPixels,pVehicle] = getAssetImage(asset,navFile,cameraParams)
% getAssetImage The bounding box, pixels of the asset in the closest image are found. 
%
%   INPUTS:
%       asset: Row from the asset data table [(nAssets,nCols), TABLE].
%       navFile: Navigation file containing all image metadata [(nImages,nCols) TABLE].
%       cameraParams: Parameters of calibrated camera [STRUCT].
%   OUTPUTS:
%       image: Image meta of closest image taken of the asset [(1,nCols) TABLE].
%       box: Bounding box of the asset in the closest image [(1,4) ARRAY].
%       targetPixels: Pixels of the asset in the closest image [(1,2) ARRAY].

% get asset dimensions. These are used to find the pixels and bounding
% boxes.
[assetDimensions,assetZ] = getAssetDimensions(asset);
% closest image
[image,box,targetPixels,pVehicle] = ...
    findClosestImage(navFile,asset,2,assetDimensions,assetZ,cameraParams);