function solveMatrices

X = sym('X'); Y = sym('Y'); Z = sym('Z'); K = 1;
X0 = sym('X0'); Y0 = sym('Y0'); Z0 = sym('Z0');
alpha = sym('alpha'); theta = sym('theta'); lambda = sym('lambda');

P = [1 0         0 0,
     0 1         0 0,
     0 0         1 0,
     0 0 -1/lambda 1];

R = [cos(theta)             sin(theta)            0          0,
    -sin(theta)*cos(alpha)  cos(theta)*cos(alpha) sin(alpha) 0,
     sin(theta)*sin(alpha) -cos(theta)*sin(alpha) cos(alpha) 0,
     0                      0                     0          1];

G = [1 0 0 -X0,
     0 1 0 -Y0,
     0 0 1 -Z0,
     0 0 0  1 ];
 
Wk = [K*X, K*Y, K*Z, K]';
Ch = P*R*G*Wk;

x = Ch(1)/Ch(4);
y = Ch(2)/Ch(4);
