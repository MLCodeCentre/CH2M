function [c,ceq] = vanishingPointConstraint(cameraParams)
% vanishing point constraint for the solver. 
u_van = 1168; v_van = 940; 

intrinsics = cameraParams(1);
rotations = cameraParams(2:4);
translations = cameraParams(5:7);

A = deg2rad(rotations(1)); B = deg2rad(rotations(2)); G = deg2rad(rotations(3));
x0 = cameraParams(4); y0 = cameraParams(5); h = cameraParams(6);
f = intrinsics(1);
%m = cameraParams(11); n = cameraParams(12);
m = 2464; n = 2056;
p1 = 0; k1 = 0; 

% Rotations
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
% Translation
T = translations';

c = [];
ceq(1) = f*R(2,1)/R(1,1) + m/2 - u_van;
ceq(2) = -f*R(3,1)/R(1,1) + n/2 - v_van; % 10 pixels away from the vanishing point. 


