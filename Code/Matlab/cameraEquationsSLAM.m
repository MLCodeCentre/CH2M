function F = cameraEquationsSLAM(params,u,v,x,y,z)

A = params(1); B = params(2); G = params(3); L1 = params(4); L2 = params(5);
%z = -params(6);

% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];

% system constants
cx = 1280; cy = 1024; m = 2560; n = 2048;