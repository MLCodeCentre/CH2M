function [u,v] = getPixelsFromCoords(coordinates,cameraParams)
%getPixelsFromCoords calculate the pixels that the position (x,y,z) in an image taken by a calibrated camera. 
%
%   INPUTS:
%       coordinates: Coordinates relative to the vehicle to be found [(3,1) ARRAY]
%       cameraParams: Paramers of calibrated camera [STRUCT]
%   OUTPUTS:
%       [u,v]: Pixels of the coordinates in the image [INT, INT].

% extrinsics
A = cameraParams.alpha; B = cameraParams.beta; G = cameraParams.gamma;
h = cameraParams.h; x0 = cameraParams.x0; y0 = cameraParams.y0;

% instrinsics
L1 = cameraParams.L1; L2 = cameraParams.L2;

m = cameraParams.m; n = cameraParams.n;
cx = cameraParams.cx; cy = cameraParams.cy;

% Rotations
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
% Translation
T = [x0, y0, h]';

Xw = coordinates; % X in the world
Xc = R*Xw - T; % X relative to the camera

% radial distortion
k1 = cameraParams.k1; k2 = cameraParams.k2;
r = sqrt(Xc(2)^2 + Xc(3)^2);
radialDistortionY = Xc(2)*(1 + k1*(r^2) + k2*(r^4));
radialDistortionZ = Xc(3)*(1 + k1*(r^2) + k2*(r^4));
% tangential distortion
p1 = cameraParams.p1; p2 = cameraParams.p2;
tangentialDistortionY = 2*p1*Xc(2)*Xc(3) + p2*(r^2 + 2*(Xc(2)^2));
tangentialDistortionZ = 2*p2*Xc(2)*Xc(3) + p1*(r^2 + 2*(Xc(3)^2));

Xc(2) = radialDistortionY + tangentialDistortionY;
Xc(3) = radialDistortionZ + tangentialDistortionZ;

% converting to pixels
u_dash = m*L1*Xc(2)/Xc(1); % this is from the centre of the image
v_dash = n*L2*Xc(3)/Xc(1);

u = u_dash + cx; % transforming coordinate system to top left
v = -v_dash + cy;