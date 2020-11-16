function [cameraParams, pixels3D, rotations] = unpackTheta(theta,nPixels,nImages)
% this functions unpacks theta into its parts - we create theta to create a
% feature vector to pass to fmincon.
cameraParams = theta(1);
theta(1) = [];
% pixel 3D coords, unpack then reshape
pixels3D_flat = theta(1:3*nPixels);
pixels3D = reshape(pixels3D_flat, [nPixels,3]);
theta(1:3*nPixels) = [];
% rotations, unpack then reshape
rotations_flat = theta; % if i've done this right, rotations should be left
rotations = reshape(rotations_flat, [nImages,3]);
end