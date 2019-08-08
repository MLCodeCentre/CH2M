function [fval,reprojections] = homogeneousProjectionFunction(cameraParams,coords,pixels)
% coords must be [x,y,z] x y in image plane z distance
fu = cameraParams(1); fv = cameraParams(2);
alpha = cameraParams(3); beta = cameraParams(4); gamma = cameraParams(5);
x0 = cameraParams(6); y0 = cameraParams(7); h = cameraParams(8);
cu = cameraParams(9); cv = cameraParams(10);

K = [fu,  0, cu; 0, fv, cv; 0,  0, 1];
RT = [rotz(gamma)*roty(beta)*rotx(alpha),[y0,h,x0]'];  
P = K*RT;

error = [];
reprojections = [];
nPixels = size(pixels,1);

for iPixel = 1:nPixels
    pixelProj = P*[coords(iPixel,:),1]';
    u = pixelProj(1)/pixelProj(3);
    v =  pixelProj(2)/pixelProj(3);
    reprojections(end+1,:) = [u,v];
    uTarget = pixels(iPixel,1);
    vTarget = pixels(iPixel,2);
    error(end+1) = norm([u-uTarget,v-vTarget]);
end

fval = norm(error);