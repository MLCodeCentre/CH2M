function roadSLAM

% uses the x,y,z,u,v data in target_data.csv to perform slam and solve the
% parameters with more and more equations. 
file_dir = fullfile(dataDir(),'A27','Year2','target_data.csv');
data_points = readtable(file_dir)

num_rows = size(data_points,1);

h = 2.5;
Xs = zeros(num_rows,5);

for D = 10:20
    data_point = data_points(1:D,:);
    U = data_point.u;
    V = data_point.v;
    X = data_point.x-2.05;
    Y = data_point.y;
    Z = -h*ones(size(U));
    
    %   options = optimoptions('lsqnonlin','Display','iter');
    [X,resnorm,res]  = lsqnonlin(@(params)cameraEquationsSLAM(params,U,V,X,Y,Z),[0,0,0,1,1,3],[],[])
    
    findRoad(X)
    %[X,FVAL,EXITFLAG] = fsolve(@(x) cameraEquationsSLAM(x,data_points,D), [0.2,0.2,0.2,1,1], options);
    next = input('Press Enter for next data point');
end

