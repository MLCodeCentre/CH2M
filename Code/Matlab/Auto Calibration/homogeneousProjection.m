function [u,v] = homogeneousProjection(coords,cameraParams)
% coords must be [x,y,z] x y in image plane z distance
alpha = cameraParams(1); beta = cameraParams(2); gamma = cameraParams(3);
x0 = cameraParams(4); h = cameraParams(5); z0 = cameraParams(6);

fu = cameraParams(7); fv = cameraParams(8);
cu = cameraParams(9); cv = cameraParams(10);

m = cameraParams(11); n = cameraParams(12);

K = [fu,  0, cu; 0, fv, cv; 0,  0, 1];
RT = [rotz(gamma)*roty(beta)*rotx(alpha),[x0,h,z0]'];  
P = K*RT;

pixelProj = P*[coords,1]';
uDash = pixelProj(1)/pixelProj(3);
vDash =  pixelProj(2)/pixelProj(3);

u = uDash + m/2; 
v = -vDash + n/2;
end