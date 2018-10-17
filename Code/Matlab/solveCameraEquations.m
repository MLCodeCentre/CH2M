function theta_solve = solveCameraEquations

% loading data
close all
file_dir = fullfile(dataDir(),'A27','Year2','target_data_road_picture.csv');
data_points = readtable(file_dir);

D = 1;
N = 3;

u = data_points(D:D+N,:).u;
v = data_points(D:D+N,:).v;
x = data_points(D:D+N,:).x - 2.05;
y = data_points(D:D+N,:).y;
z = zeros(length(D:D+N),1);
    
coords = [x,y,z,u,v];
theta_0 = [0,0,0,1,1,3];

%% this gets stuck in a local minima for more than 3 points
% options = optimoptions('fsolve','Display','iter-detailed');
% f = @(theta) cameraEquationFunction(theta,coords);
% [theta_solve,fval,exitflag,output] = fsolve(f,theta_0,options);
% theta_solve,fval,exitflag
% findRoad(theta_solve)

%% changing to global 
rng default % For reproducibility
gs = GlobalSearch;
problem = createOptimProblem('fmincon','x0',[-1,2],...
    'objective',f,'lb',[-3,-3],'ub',[3,3]);
x = run(gs,problem)



