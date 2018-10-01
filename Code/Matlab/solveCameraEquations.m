function solveCameraEquations

syms A B G L1 L2 h
% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];

% small angle formula
% R = [ (1-((G^2)/2)   -((B^2)/2)), -G*(1-(A^2/2)) + (1-((G^2)/2))*B*A,    B*(1-((G^2)/2) - ((A^2)/2));
%       G*(1-(B^2)/2),  (1-(B^2)/2)*(1-(B^2)/2) + G*B*A, -A + G*B;
%      -B,  A,          1];

% system constants
cx = 1280; cy = 1024; m = 2560; n = 2048;

% loading data
close all
file_dir = fullfile(dataDir(),'A27','Year2','target_data.csv');
data_points = readtable(file_dir);

eqs = [];

for D = 1:3
    %% getting new data point and getting distance from each particle
    data_point = data_points(D,:);
    u = data_point.u - cx;
    v = cy - data_point.v;
    x = data_point.x-2.05;
    y = data_point.y;
    z = 0;
    
    eqU = (u*R(1,1) - m*L1*R(2,1))*x + (u*R(1,2) - m*L1*R(2,2))*y + (u*R(1,3) - m*L1*R(2,3))*(z-h) == 0;
    eqV = (v*R(1,1) - n*L2*R(3,1))*x + (v*R(1,2) - n*L2*R(3,2))*y + (v*R(1,3) - n*L2*R(3,3))*(z-h) == 0;
    
    eqs = [eqs; eqU; eqV];
end


sol = vpasolve(eqs,[A,B,G,L1,L2,h]);
params = [sol.A, sol.B, sol.G, sol.L1, sol.L2, sol.h]
findRoad(params)