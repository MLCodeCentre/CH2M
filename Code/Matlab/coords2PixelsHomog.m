function [u,v] = coords2PixelsHomog(Xw, C, theta)

% Xw are the coordinates in the world - should be 3*1 Nonhomogenous coords
% C is the coords of the camera

% performing translation and rotation so Xw is now in 3d world of camera
Xc = toCameraCoords(Xw-C,theta);
% change to homogenous 
%Xc = [Xc; 1];

% There is a change of Coords Z is now distance down the road, X and Y are
% width and height respetively
Xc = [Xc(1), Xc(3), Xc(2), 1]';


params = config();
% Intrinsic parameter
K = [params.alpha_x, params.gamma,   params.cx, 0;
     0,              params.alpha_y, params.cy, 0;
     0,              0,              1,         0;];

% now just straight to pixels?!
P = K*Xc;
u = P(1)/P(3);
v = P(2)/P(3);