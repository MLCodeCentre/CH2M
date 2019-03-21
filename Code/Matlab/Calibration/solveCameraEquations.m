function solveCameraEquations(road,year)

% Initialising system parameters and data
if strcmp(year,'Year1')
    cx = 1280; cy = 1024; m = 2560; n = 2048;
elseif strcmp(year,'Year2')
    cx = 1280; cy = 1024; m = 2560; n = 2048;
elseif strcmp(year,'Year3')
    cy = 1;
end
system_params = [cx, cy, m, n];

% loading data
close all
file_dir = fullfile(dataDir(),road,year,'target_data_road_height_12_03.csv');
data_points_table1 = readtable(file_dir);

file_dir = fullfile(dataDir(),road,year,'target_data_road_height_06_03.csv');
data_points_table2 = readtable(file_dir);

file_dir = fullfile(dataDir(),road,year,'target_data_road_height_01_03.csv');
data_points_table3 = readtable(file_dir);

data_points = [data_points_table1; data_points_table2; data_points_table3];
%data_points = data_points_table2

u = data_points.u;
v = data_points.v;
x = data_points.x;
y = data_points.y;
z = data_points.z;

coords = [x,y,z,u,v];

% objective function and initial estimate
f = @(theta) cameraEquationFunction(theta,coords,system_params);
% extrinsics alpha beta gamma h x0 y0
theta_0 = [0,0,0,3,2,0];
% intrinscs = sy sz p1 p2 k1 k2
theta_0 = [theta_0,...
           100,100,0,0,0,0]; % distortion

%% solving
% ext
ub = [0.2,0.2,0.2,5,3,0.5];
% int
ub = [ub, ...
      2500,2500,0.5,0.5,0.5,0.5];
% ext
lb = [-0.2,-0.2,-0.2,0,-1,-0.5];
% int
lb = [lb, ...
      0,0,-0.5,-0.5,-0.5,-0.5];

disp('Running Global search')
problem = createOptimProblem('fmincon','objective',f,'x0',theta_0,'lb',lb,'ub',ub);
ms = MultiStart;
[xg,fg,flg,og] = run(ms,problem,5);

theta_solve = xg;
fval = fg;

%% results
show_results = true;
if show_results
    % exts
    alpha = theta_solve(1); beta = theta_solve(2); gamma = theta_solve(3);
    h = theta_solve(4); x0 = theta_solve(5);  y0 = theta_solve(6); 
    % ints
    fy = theta_solve(7); fz = theta_solve(8);
    k1 = theta_solve(9); k2 = theta_solve(10); 
    p1 = theta_solve(11); p2 = theta_solve(12); 


    fprintf('Solved with residual %f parameter values: \n',fval);
    fprintf('--------Extrinsic Parameters---------\n')
    fprintf(' alpha (roll) : %2.4f degs \n beta (tilt) : %2.4f degs \n gamma (pan) : %2.4f degs\n', rad2deg(alpha), rad2deg(beta), rad2deg(gamma));
    fprintf(' h : %2.4f m  \n x0 : %2.4f m  \n y0 : %2.4f m \n', h, x0, y0)
    fprintf('--------Intrinsic Parameters---------\n')
    %fprintf(' L1 : %2.4f \n', L1);
    %fprintf(' L2 : %2.4f \n', L2);
    fprintf(' fy : %2.4f \n', fy);
    fprintf(' fz : %2.4f \n', fz);
    fprintf(' k1 : %2.8f \n', k1);
    fprintf(' k2 : %2.8f \n', k2);
    fprintf(' p1 : %2.8f \n', p1);
    fprintf(' p2 : %2.8f \n', p2);

    findRoad(theta_solve,system_params,road,year);
    figure
    findTargets(data_points,theta_solve,system_params);
end

%% saving
save = true;
if save
   %roll = Alpha; tilt = Beta; pan = Gamma;
   calibration_parameters = table(alpha,beta,gamma,h,x0,y0,h,cx,cy,m,n,fy,fz,k1,k2,p1,p2);
   out_file = fullfile(dataDir(),road,year,'calibration_parameters.csv');
   writetable(calibration_parameters,out_file,'QuoteStrings',true); 
   disp('saved camera parameters')
end