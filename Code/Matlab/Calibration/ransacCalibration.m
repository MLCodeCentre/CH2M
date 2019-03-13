function ransacCalibration(road,year)

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

% file_dir = fullfile(dataDir(),road,year,'target_data_road_height_12_03_second.csv');
% data_points_table4 = readtable(file_dir);

data_points_table = [data_points_table1; data_points_table2; data_points_table3];

data_points = data_points_table;
data_points = table2array(data_points(:,2:end));
%% ransac
% defining ransac fitting function and distance function
fitThetaFnc = @(data_points) solveCameraEquation(data_points,system_params);
distFcn = @(theta,data_points) comparePixels(theta,data_points,system_params);
% running ransac
[theta_solve, inlierIdx] = ransac(data_points,fitThetaFnc,distFcn,20,30);
inlierIdx
%% results
findRoad(theta_solve,system_params,road,year);
figure
findRansacTargets(data_points_table,theta_solve,system_params,inlierIdx);
% figure
% findRansacTargets(data_points_2,theta_solve,system_params,inlierIdx(num_data_points_1+1:end));

Alpha = theta_solve(1); Beta = theta_solve(2); Gamma = theta_solve(3);
L1 = theta_solve(4); L2 = theta_solve(5); 
h = theta_solve(6); x0 = theta_solve(7); y0 = theta_solve(8);

%fprintf('Solved with residual %f parameter values: \n',fval);
fprintf('--------Extrinsic Parameters---------\n')
fprintf(' alpha (roll): %2.4f degs \n beta (tilt): %2.4f degs \n gamma (pan): %2.4f degs\n', rad2deg(Alpha), rad2deg(Beta), rad2deg(Gamma));
fprintf(' x0 : %2.4f m  \n y0 : %2.4f m  \n h : %2.4f m \n', x0, y0, h)
fprintf('--------Intrinsic Parameters---------\n')
fprintf(' L1 : %2.4f \n', L1);
fprintf(' L2 : %2.4f \n', L2);

%% saving
save = true;
if save
   roll = Alpha; tilt = Beta; pan = Gamma;
   calibration_parameters = table(roll,tilt,pan,L1,L2,x0,y0,h,cx,cy,m,n);
   out_file = fullfile(dataDir(),road,year,'calibration_parameters_test.csv');
   writetable(calibration_parameters,out_file,'QuoteStrings',true); 
   disp('saved camera parameters')
end

end

function distances = comparePixels(theta,data_points,system_params)
    params.alpha = theta(1); params.beta = theta(2); params.gamma = theta(3);
    params.L1 = theta(4); params.L2 = theta(5);
    params.h = theta(6); params.x0 = theta(7); params.y0 = theta(8);

    params.cx = system_params(1); params.cy = system_params(2); 
    params.m = system_params(3); params.n = system_params(4);
    
    u = data_points(:,4);
    v = data_points(:,5);
    x = data_points(:,2);
    y = data_points(:,1);
    z = data_points(:,3);
    
    num_data_points = size(data_points,1);
    for i = 1:num_data_points
        [u_model, v_model] = getPixelsFromCoords(x(i),y(i),z(i), params);
        distances(i) = sqrt((u(i)-u_model)^2 + (v(i)-v_model)^2);
    end
end

function theta_solve = solveCameraEquation(data_points,system_params)
    
    u = data_points(:,4);
    v = data_points(:,5);
    x = data_points(:,2);
    y = data_points(:,1);
    z = data_points(:,3);

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

end



