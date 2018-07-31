function roadSLAM

%% uses the x,y,z,u,v data in target_data.csv to perform slam and solve the
% parameters with more and more equations. 
file_dir = fullfile(dataDir(),'A27','Year2','target_data.csv');
data_points = readtable(file_dir);

%num_rows = size(data_points,1);

options = optimoptions('fsolve',...
                       'MaxFunctionEvaluations',10000, 'MaxIterations',10000);
                       %'Display','iter'
%h = 3.5;
D = 5;
for D = 5;
[X,FVAL,EXITFLAG] = fsolve(@(x) cameraEquationsSLAM(x,data_points,D), [0.2,0.2,0.2,1], options);
X
sum(FVAL)
end