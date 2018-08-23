function F = cameraEquationsSLAM(params,u,v,x,y)

A = params(1); B = params(2); G = params(3); L1 = params(4); L2 = params(5);
z = -params(6);

% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];

% system constants
cx = 1280; cy = 1024; m = 2560; n = 2048;

eq1 = (u-cx) - m*L1*((R(2,1).*x + R(2,2).*y + R(2,3).*z)...
                    ./(R(1,1).*x + R(1,2).*y + R(1,3).*z));

eq2 = (cy-v) - n*L2*((R(3,1).*x + R(3,2).*y + R(3,3).*z)...
                    ./(R(1,1).*x + R(1,2).*y + R(1,3).*z));

F = sqrt(eq1.^2 + eq2.^2);
