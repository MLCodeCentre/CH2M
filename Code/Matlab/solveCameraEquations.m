function theta_solve = solveCameraEquations(road,year)

height_known = true;
x0y0_known = true;
%% Initialising system parameters and data
if strcmp(year,'Year1')
    x_cam = 1.58; y_cam = 0;
    system_params = [1280, 1024, 2560, 2048, x_cam, y_cam]; %cx    cy    m      n
elseif strcmp(year,'Year2')
    x_cam = 2.05; y_cam = 0;
    system_params = [1280, 1024, 2560, 2048, x_cam, y_cam];
elseif strcmp(year,'Year3')
    x_cam = 3.1; y_cam = -0.1221;
    system_params = [1232, 1028, 2464, 2056, x_cam, y_cam];
end

% loading data
close all
file_dir = fullfile(dataDir(),road,year,'target_data_road_2.csv');
data_points = readtable(file_dir);
num_data_points = size(data_points,1);

fprintf('%d data points in %s\n',num_data_points,year);

%% solving 
%D = 21;
n = 3;
D = num_data_points - (n-1);
fprintf('Solving with %d data points\n',n);

data_points = data_points(D:D+(n-1),:);
u = data_points.u;
v = data_points.v;
x = data_points.x;
y = data_points.y;
z = zeros(n,1);
    
if height_known == true
    coords = [x,y,z,u,v];
    theta_0 = [0,0,0,1,1,3];
    if x0y0_known == false
        theta_0 = [theta_0,2,0];
    end
    f = @(theta) cameraEquationFunction(theta,coords,system_params);
else
    coords = [x,y,u,v];
    theta_0 = [0,0,0,1,1,3];
    for i = 1:n
        theta_0 = [theta_0, 0];
    end
    f = @(theta) cameraEquationFunctionNoHeight(theta,coords,system_params);
end


disp('Running fminunc')
options = optimoptions('fminunc','MaxFunctionEvaluations',10000,'MaxIterations',10000,'FunctionTolerance',1E-08);
[xfmu,fvalfmu,eflagfmu,outputfmu] = fminunc(f,theta_0,options)
% disp('---------------------')
% disp('Running fmincon')
%ub = [ pi/4,  pi/4,  pi/4,  5,    5,    4];
%lb = [-pi/4, -pi/4, -pi/4,  0.1,  0.1,  1];
%[xfmc,fvalfmc,eflagfmc,outputfmc] = fmincon(f,theta_0,[],[],[],[],lb,ub)
disp('Running patternsearch')
[xp,fp,flp,op] = patternsearch(f,theta_0,[],[],[],[],[],[],options)

disp('Running Global search')
problem = createOptimProblem('fmincon','objective',f,'x0',theta_0);
gs = GlobalSearch;
[xg,fg,flg,og] = run(gs,problem)

theta_solve = xg
fval = fvalfmu;

Alpha = rad2deg(theta_solve(1)); Beta = rad2deg(theta_solve(2)); Gamma = rad2deg(theta_solve(3));
L1 = theta_solve(4); L2 = theta_solve(5); h = theta_solve(6); x0 = x_cam; y0 = y_cam;
if x0y0_known == false
    x0 = theta_solve(7); y0 = theta_solve(8);
end

fprintf('Solved with residual %f parameter values: \n',fval);
fprintf(' alpha (roll): %2.4f degs \n beta (tilt): %2.4f degs \n gamma (pan): %2.4f degs\n', Alpha, Beta, Gamma);
fprintf(' L1 : %2.4f \n L2: %2.4f \n h: %2.4f m \n', L1, L2, h);
if height_known == false
    for i = 1:n
        z = theta_solve(6+i);
        fprintf(' Target %d height: %2.4f \n',i,z);
    end
end

% dthetadu(theta_solve,coords,system_params)
if x0y0_known == false
    fprintf(' x0 : %2.4f m  x0 : %2.4f m \n', x0, y0);
end
%errorSurface(theta_solve,coords,system_params)
findRoad(theta_solve,system_params,road,year)

