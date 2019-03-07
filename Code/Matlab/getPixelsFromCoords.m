function [u,v] = getPixelsFromCoords(x,y,z,params)

A = params.alpha; B = params.beta; G = params.gamma;
h = params.h; x0 = params.x0; y0 = params.y0;

L1 = params.L1; L2 = params.L2;

m = params.m; n = params.n;
cx = params.cx; cy = params.cy;

% Rotations
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
% Translation
T = [x0, y0, h]';

Xw = [x,y,z]'; % X in the world
Xc = R*Xw - T; % X relative to the camera

u_dash = m*L1*Xc(2)/Xc(1); % this is from the centre of the image
v_dash = n*L2*Xc(3)/Xc(1);
     
u = u_dash + cx; % transforming coordinate system to top left
v = -v_dash + cy;