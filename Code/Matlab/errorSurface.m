function errorSurface(road,year)
% solving as usual.
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

D = 18;
N = 2;

u = data_points(D:D+N,:).u;
v = data_points(D:D+N,:).v;
x = data_points(D:D+N,:).x;
y = data_points(D:D+N,:).y;
z = zeros(length(D:D+N),1);

coords = [x,y,z,u,v];
theta_0 = [0,0,0,1,1,3];
%ub = [ pi/4,  pi/4,  pi/4,  5,    5,    3];
%lb = [-pi/4, -pi/4, -pi/4,  0.1,  0.1,  3];

f = @(theta) cameraEquationFunction(theta,coords,system_params);
options = optimoptions('fminunc','MaxFunctionEvaluations',1000,'FunctionTolerance',1E-08,'Display','off');
[theta_solve,fvalfmu,eflagfmu,outputfmu] = fminunc(f,theta_0,options);

plotChanges(theta_solve, coords, system_params, [1,0,0,0,0,0], -0.01:0.0001:0.01, '\alpha')
plotChanges(theta_solve, coords, system_params, [0,1,0,0,0,0], -0.5:0.01:0.5, '\beta')
plotChanges(theta_solve, coords, system_params, [0,0,1,0,0,0], -0.5:0.01:0.5, '\gamma')
plotChanges(theta_solve, coords, system_params, [0,0,0,1,0,0], -0.4:0.01:0.4, 'L1')
plotChanges(theta_solve, coords, system_params, [0,0,0,0,1,0], -0.4:0.01:0.4, 'L2')
plotChanges(theta_solve, coords, system_params, [0,0,0,0,0,1], -3:0.1:3, 'h')

end

function plotChanges(theta_solve, coords, system_params, change_vector, param_range, parameter)
    figure;
    fvals = [];
    for dp = param_range
        theta_dp = theta_solve + dp*change_vector;
        fval = cameraEquationFunction(theta_dp,coords,system_params);
        fvals = [fvals, fval];
    end
    plot(param_range,fvals); xlabel(strcat('\delta', parameter)); ylabel('fval');
end



