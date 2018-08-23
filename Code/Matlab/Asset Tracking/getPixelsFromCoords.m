function [u,v] = getPixelsFromCoords(x,y,z,params)

A = params.alpha; B = params.beta; G = params.gamma; 
L1 = params.L1; L2 = params.L2;

m = params.m; n = params.n;
cx = params.cx; cy = params.cy;

R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];


u = m*L1*((R(2,1).*x + R(2,2).*y + R(2,3).*z)...
        ./(R(1,1).*x + R(1,2).*y + R(1,3).*z)) + cx;

v = -n*L2*((R(3,1).*x + R(3,2).*y + R(3,3).*z)...
         ./(R(1,1).*x + R(1,2).*y + R(1,3).*z)) + cy;