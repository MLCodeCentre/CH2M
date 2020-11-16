function [u,v] = projection2D(cameraParams,coords)

A = cameraParams(1); B = cameraParams(2); G = cameraParams(3); % ALPHA BETA GAMMA
x0 = cameraParams(4); y0 = cameraParams(5); h = cameraParams(6); % OFFSETS
f = cameraParams(7); % FOCAL LENGTH
m = cameraParams(8); n = cameraParams(9);

% Rotations
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
% Translation
T = [x0, y0, h]';

coordsCam = R*coords - T; % X relative to the camera

% projection
u = f*coordsCam(2)/coordsCam(1) - m/2;
v = -f*coordsCam(3)/coordsCam(1) + n/2;

end