function ransacCalibration(road,year)

% Initialising system parameters and data
% Initialising system parameters and data
if strcmp(year,'Year1')
    cx = 1280; cy = 1024; m = 2560; n = 2048;
elseif strcmp(year,'Year2')
    cx = 1280; cy = 1024; m = 2560; n = 2048;
elseif strcmp(year,'Year3')
    cx = 1232; cy = 1028; m = 2464; n = 2056;
end
systemParams = [cx, cy, m, n];

% loading data
close all
fileDir = fullfile(dataDir(),road,year,'target_data_road_height_12_03.csv');
dataTable1 = readtable(fileDir);
fileDir = fullfile(dataDir(),road,year,'target_data_road_height_06_03.csv');
dataTable2 = readtable(fileDir);
fileDir = fullfile(dataDir(),road,year,'target_data_road_height_01_03.csv');
dataTable3 = readtable(fileDir);
dataPointsTable = [dataTable1;dataTable2;dataTable3];
%dataPointsTable = dataTable3;
data = [dataTable2;dataTable3];
dataPoints = table2array(dataPointsTable(:,{'u','v','x','y','z'}));


%% ransac
% defining ransac fitting function and distance function
fitThetaFnc = @(dataPoints) solveCameraEquation(dataPoints,systemParams);
distFcn = @(theta,dataPoints) comparePixels(theta,dataPoints,systemParams);
% running ransac
[thetaSolve, inlierIdx] = ransac(dataPoints,fitThetaFnc,distFcn,10,50);
inlierIdx
%% results
findRoad(thetaSolve,systemParams,road,year);
figure
%findRansacTargets(dataPointsTable,thetaSolve,systemParams,inlierIdx);

% exts
alpha = thetaSolve(1); beta = thetaSolve(2); gamma = thetaSolve(3);
x0 = thetaSolve(4); y0 = thetaSolve(5);  h = thetaSolve(6); 
% ints
fu = thetaSolve(7); fv = thetaSolve(8);
cu = thetaSolve(9); cv = thetaSolve(10);
k1 = thetaSolve(11); p1 = thetaSolve(12); 
% = thetaSolve(11); p2 = thetaSolve(12);

%s = thetaSolve(15);

%fprintf('Solved with residual %f parameter values: \n',fval);
fprintf('--------Extrinsic Parameters---------\n')
fprintf(' alpha (roll) : %2.4f degs \n beta (tilt) : %2.4f degs \n gamma (pan) : %2.4f degs\n', rad2deg(alpha), rad2deg(beta), rad2deg(gamma));
fprintf(' x0 : %2.4f m  \n y0 : %2.4f m  \n h : %2.4f m \n', x0, y0, h)
fprintf('--------Intrinsic Parameters---------\n')
fprintf(' fu : %2.4f \n', fu);
fprintf(' fv : %2.4f \n', fv);
fprintf(' k1 : %2.8f \n', k1);
fprintf(' k2 : %2.8f \n', k2);
fprintf(' p1 : %2.8f \n', p1);
fprintf(' p2 : %2.8f \n', p2);
fprintf(' cu : %2.2f \n', cu);
fprintf(' cv : %2.2f \n', cv);
fprintf(' s : %2.8f \n', s);

%% saving
save = false;
if save
   roll = Alpha; tilt = Beta; pan = Gamma;
   calibration_parameters = table(roll,tilt,pan,L1,L2,x0,y0,h,cx,cy,m,n,k1,k2,p1,p2);
   out_file = fullfile(dataDir(),road,year,'calibration_parameters.csv');
   writetable(calibration_parameters,out_file,'QuoteStrings',true); 
   disp('saved camera parameters')
end

end

function distances = comparePixels(theta,dataPoints,systemParams)
    
    params.alpha = theta(1); params.beta = theta(2); params.gamma = theta(3);
    params.x0 = theta(4); params.y0 = theta(5); params.h = theta(6);
    params.fu = theta(7); params.fv = theta(8);
    params.cu = theta(9); params.cv = theta(10); 
    params.p1 = theta(11); params.k1 = theta(12); 
    params.m = systemParams(3); params.n = systemParams(4);
    
    u = dataPoints(:,1);
    v = dataPoints(:,2);
    x = dataPoints(:,3);
    y = dataPoints(:,4);
    z = dataPoints(:,5);
    
    numDataPoints = size(dataPoints,1);
    for i = 1:numDataPoints
        [u_model(i), v_model(i)] = getPixelsFromCoords([x(i),y(i),z(i)]', params);
        distances(i) = sqrt((u(i)-u_model(i))^2 + (v(i)-v_model(i))^2);
    end
    mean(distances)
end

function thetaSolve = solveCameraEquation(dataPoints,systemParams)
    
    u = dataPoints(:,1);
    v = dataPoints(:,2);
    x = dataPoints(:,3);
    y = dataPoints(:,4);
    z = dataPoints(:,5);

    coords = [x,y,z,u,v];

    f = @(theta) cameraEquationFunction(theta,coords,systemParams);

    alphaInit = 0; alphaLB = -0.2; alphaUB = 0.2;
    betaInit = 0; betaLB = -0.2; betaUB = 0.2;
    gammaInit = 0; gammaLB = -0.2; gammaUB = 0.2;
    x0Init = 1; x0LB = 0; x0UB = 6;
    y0Init = 0; y0LB = -0.5; y0UB = 0.5;
    hInit = 3; hLB = 1; hUB = 4;
    fInit = 4000; fLB = 1000; fUB = 7000;
    cuInit = 0; cuLB = 0; cuUB = 0;
    cvInit = 0; cvLB = 0; cvUB = 0;
    k1Int = 0; k1LB =  0; k1UB = 0;
    p1Int = 0; p1LB =  0; p1UB = 0;

    % creating initial guess and bounds vectors
    thetaInit = [alphaInit, betaInit, gammaInit, x0Init, y0Init, hInit, fInit, fInit, cuInit, cvInit, k1Int, p1Int];
    thetaLB = [alphaLB, betaLB, gammaLB, x0LB, y0LB, hLB, fLB, fLB, cuLB, cvLB, k1LB, p1LB];
    thetaUB = [alphaUB, betaUB, gammaUB, x0UB, y0UB, hUB, fUB, fUB, cuUB, cvUB, k1UB, p1UB];


    disp('Running Global search')
    options = optimset('TolFun',1e-6,'TolX',1e-6);
    problem = createOptimProblem('fmincon','objective',f,'x0',thetaInit,'lb',thetaLB,'ub',thetaUB,'options',options);
    ms = MultiStart;
    [xg,fg,flg,og] = run(ms,problem,3);

    thetaSolve = xg;
    fval = fg;

end