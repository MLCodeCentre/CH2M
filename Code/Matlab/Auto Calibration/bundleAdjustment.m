function [fval, error] = bundleAdjustment(theta,pixels,translations,nPixels,nImages)
% theta contains the camera parameters, pixel 3D coord and rotations. 
[cameraParams, pixels3D, rotations] = unpackTheta(theta,nPixels,nImages);
%% now we can run the reprojection error over all of these things. 
[fval, error] = reprojectionFunction(pixels,cameraParams,pixels3D,rotations,translations,nPixels,nImages);
end