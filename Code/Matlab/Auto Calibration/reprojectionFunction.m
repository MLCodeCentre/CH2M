%% This is the overarching, each of the arguments will be optimsed reprojection error function.
function [fval, error] = reprojectionFunction(pixels,cameraParams,pixels3D,rotations,translations,nPixels,nImages)
% for each pixel coord in pixels3D, we rotate it, and translate (one for each row in the args)
% then we project it according to cameraParams. The reprojection error (against vals in pixels)
% is the calculated.
m = 2465; n = 2056;
error = [];
% camera params
fu = cameraParams(1); fv = cameraParams(1); cu = 0; cv = 0;
% loop through each of the images
for iImage = 1:nImages
    % unpack rotation vector and turn into a matrix
    alpha = rotations(iImage,1); beta = rotations(iImage,2); gamma = rotations(iImage,3);
    R = rotationMatrix(alpha,beta,gamma);
    % translation matrix
    t = translations(iImage,:)';
    % now loop through each of the pixels true 3D coordinate
    for iPixel = 1:nPixels
        X_world = pixels3D(iPixel,:)';
        X_camera = R*X_world - t;
        X_camera = [X_camera(2); X_camera(1); X_camera(3)];
        % projections
        u = fu*(X_camera(2)/X_camera(1)) + cu;
        v = fv*(X_camera(3)/X_camera(1)) + cv;
        u = u + m/2;
        v = -v + n/2;
        % calc euc distance as errr
        error(end+1) = norm([u-pixels(iImage,iPixel,1),v-pixels(iImage,iPixel,2)]);
    end
end
fval = sum(error);
end