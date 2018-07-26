function F = cameraEquationFunction(params,coords)
% constants
m = 4032; cx = 2016; % >
n = 3024; cy = 1512; % ^

% parameters to be found
A = params(1);
B = params(2);
G = params(3);
L1 = params(4);
L2 = params(5);

% coords
x = coords(1);
y = coords(2);
z = coords(3);

%% Equation to minimise. Because of the 2D output I'll minimise sqrt(u^2 + v^2)

u = m*L1*(...
         (x*(cos(G)*cos(B)) + y*(-sin(G)*cos(A) + cos(G)*sin(B)*sin(A)) + z*(sin(G)*sin(A) + cos(G)*sin(B)*cos(A)))/...
         (x*(sin(G)*cos(B)) + y*(cos(B)*cos(A) + sin(G)*sin(B)*sin(A)) + z*(-cos(G)*sin(A) + sin(G)*sin(B)*cos(A)))...
         );
 
v = n*L2*(...
         (x*(-sin(B)) + y*(cos(B)*sin(A)) + z*(cos(B)*cos(A)))/...
         (x*(sin(G)*cos(B)) + y*(cos(B)*cos(A) + sin(G)*sin(B)*sin(A)) + z*(-cos(G)*sin(A) + sin(G)*sin(B)*cos(A)))...
         );
     
u = u + cx; v = cy - v;
F = sqrt(u^2 + v^2);
 