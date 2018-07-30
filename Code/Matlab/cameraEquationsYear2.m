function F = cameraEquationsYear2(params,h)

% splitting up system variables in p
%params = [A B G L1 L2]
A = params(1); B = params(2); G = params(3); L1 = params(4); L2 = params(5);
%h = params(6);
% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];

% system constants
cx = 1280; cy = 1024; m = 2560; n = 2048;

% fist lane marker
y = 1.6253; x = 5.7749 - 2.05; z = -h; u = 2111; v = 1983;

eq1 = (u-cx) - m*L1*((R(2,1)*x + R(2,2)*y + R(2,3)*z)...
                    /(R(1,1)*x + R(1,2)*y + R(1,3)*z));

eq2 = (cy-v) - n*L2*((R(3,1)*x + R(3,2)*y + R(3,3)*z)...
                    /(R(1,1)*x + R(1,2)*y + R(1,3)*z));

% second square in road
y = 1.2111; x = 28.3362 - 2.05; z = -h; u = 1411; v = 990;

eq3 = (u-cx) - m*L1*((R(2,1)*x + R(2,2)*y + R(2,3)*z)...
                    /(R(1,1)*x + R(1,2)*y + R(1,3)*z));

eq4 = (cy-v) - n*L2*((R(3,1)*x + R(3,2)*y + R(3,3)*z)...
                    /(R(1,1)*x + R(1,2)*y + R(1,3)*z));
           
% vanishing points
up = 1290; 
eq5 = (up-cx) - m*L1*(R(2,1)...
                     /R(1,1));
                   
vp = 803; 
eq6 = (cy-vp) - n*L2*(R(3,1)...
                     /R(1,1));
 
% Collating the equations to solve for the 5 unknowns
F = [eq1, eq2, eq3, eq4, eq5, eq6];