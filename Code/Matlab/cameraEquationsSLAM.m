function F = cameraEquationsSLAM(params,data,D)

A = params(1); B = params(2); G = params(3); L12 = params(4);
%h = params(6);
% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];

% system constants
cx = 1280; cy = 1024; m = 2560; n = 2048;
h = 3.5;
F = [];
for d = 1:D
    row = data(d,:);
    x = row.x - 2.05; y = row.y; z = -h; u = row.u; v = row.v;
    eq = (u-cx) - (m/n)*L12*((R(2,1)*x + R(2,2)*y + R(2,3)*z)/...
                             (R(3,1)*x + R(3,2)*y + R(3,3)*z))*(cy-v);
    F = [F, eq];
end
