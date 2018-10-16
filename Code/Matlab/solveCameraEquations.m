function theta_solve = solveCameraEquations(road,year)

%% Initialising system parameters and data
if strcmp(year,'Year1')
                     %cx    cy    m      n
    system_params = [1280, 1024, 2560, 2048];
    x_cam = 2.05;
elseif strcmp(year,'Year2')
    system_params = [1280, 1024, 2560, 2048];
    x_cam = 2.05;
elseif strcmp(year,'Year3')
    system_params = [1232, 1028, 2464, 2056];
    x_cam = 3;
end


% loading data
close all
file_dir = fullfile(dataDir(),road,year,'target_data_road_picture.csv');
data_points = readtable(file_dir);

str = sprintf('%d data points in %s',size(data_points,1),year);
disp(str);

%% solving 
D = 4;
N = size(data_points,1)-D;

thetas = [];

for n = N

u = data_points(D:D+n,:).u;
v = data_points(D:D+n,:).v;
x = data_points(D:D+n,:).x;
y = data_points(D:D+n,:).y;
z = zeros(length(D:D+n),1);
    
coords = [x,y,z,u,v];
theta_0 = [0,0,0,1,1,2,0,0];
ub = [ pi/4,  pi/4,  pi/4,  5,    5,    4, 2.05, 0];
lb = [-pi/4, -pi/4, -pi/4,  0.5,  0.5,  1, 2.05, 0];

% after 3 points this gets stuck in a local minima
% options = optimoptions('fsolve','Display','iter-detailed');
% f = @(theta) cameraEquationFunction(theta,coords);
% options = optimoptions('fmincon','Display','iter','StepTolerance',1e-16);
% [theta_solve,fval,exitflag,output] = fmincon(f,theta_0,[],[],[],[],[],[]);
% theta_solve,fval,exitflag


%% global optimisation
f = @(theta) cameraEquationFunction(theta,coords,system_params);
options = optimoptions(@fmincon,'StepTolerance',1e-16);
problem = createOptimProblem('fmincon','objective',f, 'x0', theta_0,'lb',lb,'ub',ub,'options',options);
ms = MultiStart;
[theta_solve, fval] = run(ms, problem, 20);
thetas = [thetas; theta_solve]

end
findRoad(theta_solve,road,year)
Alpha = rad2deg(theta_solve(1)); Beta = rad2deg(theta_solve(2)); Gamma = rad2deg(theta_solve(3));
L1 = theta_solve(4); L2 = theta_solve(5); h = theta_solve(6); x0 = theta_solve(7); y0 = theta_solve(8);

fprintf('Solved with residual %f parameter values: \n',fval);
fprintf(' alpha (roll): %2.2f degs \n beta (tilt): %2.2f degs \n gamma (pan): %2.2f degs\n', Alpha, Beta, Gamma);
fprintf(' L1 : %2.2f \n L2: %2.2f\n', L1, L2);
fprintf(' x0 : %2.2f m \n y0: %2.2f m \n h: %2.2f m \n', x0, y0, h);
