function theta_solve = solveCameraEquations(road,year)

%% Initialising system parameters and data
if strcmp(year,'Year1')
    x_cam = 2.05; y_cam = 0;
                     %cx    cy    m      n
    system_params = [1280, 1024, 2560, 2048, x_cam, y_cam];   
elseif strcmp(year,'Year2')
    x_cam = 2.05; y_cam = 0;
    system_params = [1280, 1024, 2560, 2048, x_cam, y_cam];
elseif strcmp(year,'Year3')
    x_cam = 2.05; y_cam = 0;
    system_params = [1232, 1028, 2464, 2056, x_cam, y_cam];
end


% loading data
close all
file_dir = fullfile(dataDir(),road,year,'target_data_road_2.csv');
data_points = readtable(file_dir);

fprintf('%d data points in %s\n',size(data_points,1),year);

%% solving 
Num_Targets = 3;
D = 18;
N = size(data_points,1)-D;

thetas = [];

for n = 2

u = data_points(D:D+n,:).u;
v = data_points(D:D+n,:).v;
x = data_points(D:D+n,:).x;
y = data_points(D:D+n,:).y;
z = zeros(length(D:D+n),1);
    
coords = [x,y,z,u,v];
theta_0 = [0,0,0,1,1,3];
ub = [ pi/4,  pi/4,  pi/4,  5,    5,    3];
lb = [-pi/4, -pi/4, -pi/4,  0.1,  0.1,  3];

f = @(theta) cameraEquationFunction(theta,coords,system_params);

%% local
% [theta_local,fval] = fmincon(f,theta_0,[],[],[],[],lb,ub)
% findRoad(theta_local,system_params,road,year)

%% global optimisation
% options = optimoptions(@fmincon,'StepTolerance',1e-16,'OptimalityTolerance',1e-6);
% problem = createOptimProblem('fmincon','objective',f, 'x0', theta_0,'lb',lb,'ub',ub,'options',options);
% ms = GlobalSearch;
% [theta_solve, fval] = run(ms, problem);
% thetas = [thetas; theta_solve];

% %% using patternsearch
% disp('---------------------')
% disp('Running Pattern Seach')
% [xps,fvalps,eflagps,outputps] = patternsearch(f,theta_0,[],[],[],[],lb,ub);
% disp('---------------------')
% disp('Running fmin Seach')
% [xfms,fvalfms,eflagfms,outputfms] = fminsearch(f,theta_0);
% disp('---------------------')
% disp('Running Particle Swarm')
% [xpsw,fvalpsw,eflagpsw,outputpsw] = particleswarm(f,6,lb,ub);
% disp('---------------------')
% disp('Running Genertic Alogirithm')
% [xga,fvalga,eflagga,outputga] = ga(f,6);
% disp('---------------------')
disp('Running fminunc')
options = optimoptions('fminunc','MaxFunctionEvaluations',1000,'FunctionTolerance',1E-08);
[xfmu,fvalfmu,eflagfmu,outputfmu] = fminunc(f,theta_0,options);
disp('---------------------')
disp('Running fmincon')
[xfmc,fvalfmc,eflagfmc,outputfmc] = fmincon(f,theta_0,[],[],[],[],lb,ub);


end

%% this gets stuck in a local minima for more than 3 points
% options = optimoptions('fsolve','Display','iter-detailed');
% f = @(theta) cameraEquationFunction(theta,coords);
% [theta_solve,fval,exitflag,output] = fsolve(f,theta_0,options);
% theta_solve,fval,exitflag
% findRoad(theta_solve)

%%displaying results
% Solver = {'patternsearch';'fminsearch';'particleswarm';'ga';'fminunc';'fmincon'};
% FVal = [fvalps,fvalfms,fvalpsw,fvalga,fvalfmu,fvalfmc]';
% NumEval = [outputps.funccount,outputfms.funcCount,outputpsw.funccount,...
%     outputga.funccount,outputfmu.funcCount,outputfmc.funcCount]';
% results = table(Solver,FVal,NumEval)

theta_solve = xfmu; fval = fvalfmu;
findRoad(theta_solve,system_params,road,year)
Alpha = rad2deg(theta_solve(1)); Beta = rad2deg(theta_solve(2)); Gamma = rad2deg(theta_solve(3));
L1 = theta_solve(4); L2 = theta_solve(5); h = theta_solve(6); x0 = x_cam; y0 =y_cam;

fprintf('Solved with residual %f parameter values: \n',fval);
fprintf(' alpha (roll): %2.4f degs \n beta (tilt): %2.4f degs \n gamma (pan): %2.4f degs\n', Alpha, Beta, Gamma);
fprintf(' L1 : %2.4f \n L2: %2.4f\n', L1, L2);
fprintf(' x0 : %2.4f m \n y0: %2.4f m \n h: %2.4f m \n', x0, y0, h);
