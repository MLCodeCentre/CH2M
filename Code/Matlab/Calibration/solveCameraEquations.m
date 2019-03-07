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
file_dir = fullfile(dataDir(),road,year,'target_data_road_height_01_03.csv');
data_points_1 = readtable(file_dir);

file_dir = fullfile(dataDir(),road,year,'target_data_road_height_06_03.csv');
data_points_2 = readtable(file_dir);

data_points = [data_points_1; data_points_2];
%data_points = data_points(data_points.x<20,:)

u = data_points.u;
v = data_points.v;
x = data_points.x;
y = data_points.y;
z = data_points.z;

coords = [x,y,z,u,v];

% objective function and initial estimate
f = @(theta) cameraEquationFunction(theta,coords,system_params);
theta_0 = [0,0,0,1,1,3,2,0];

%% solving 
ub = [ 0.2,  0.2,  0.2,  3,    3,    5, 3,  0.5];
lb = [-0.2, -0.2, -0.2,  0.1,  0.1,  1, 0, -0.5];
disp('Running Global search')
problem = createOptimProblem('fmincon','objective',f,'x0',theta_0,'lb',lb,'ub',ub);
ms = MultiStart;
[xg,fg,flg,og] = run(ms,problem,5);

theta_solve = xg;
fval = fg;

%% results
show_results = true;
if show_results
    Alpha = theta_solve(1); Beta = theta_solve(2); Gamma = theta_solve(3);
    L1 = theta_solve(4); L2 = theta_solve(5); 
    h = theta_solve(6); x0 = theta_solve(7); y0 = theta_solve(8);

    fprintf('Solved with residual %f parameter values: \n',fval);
    fprintf('--------Extrinsic Parameters---------\n')
    fprintf(' alpha (roll): %2.4f degs \n beta (tilt): %2.4f degs \n gamma (pan): %2.4f degs\n', rad2deg(Alpha), rad2deg(Beta), rad2deg(Gamma));
    fprintf(' x0 : %2.4f m  \n y0 : %2.4f m  \n h : %2.4f m \n', x0, y0, h)
    fprintf('--------Intrinsic Parameters---------\n')
    fprintf(' L1 : %2.4f \n', L1);
    fprintf(' L2 : %2.4f \n', L2);

    findRoad(theta_solve,system_params,road,year);
    figure
    findTargets(data_points,theta_solve,system_params);
end

%% saving
save = false;
if save
   roll = Alpha; tilt = Beta; pan = Gamma;
   calibration_parameters = table(roll,tilt,pan,L1,L2,x0,y0,h,cx,cy,m,n);
   out_file = fullfile(dataDir(),road,year,'calibration_parameters.csv');
   writetable(calibration_parameters,out_file,'QuoteStrings',true); 
   disp('saved camera parameters')
end

