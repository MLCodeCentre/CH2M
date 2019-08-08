function solveCameraEquations(road,year)

% Initialising system parameters and data
if strcmp(year,'Year1')
    m = 2560; n = 2048;
    vanishingPoint = [1237,1004];
elseif strcmp(year,'Year2')
    m = 2560; n = 2048;
    vanishingPoint = [1282,812]; 
elseif strcmp(year,'Year3')
    m = 2464; n = 2056;
end
systemParams = [m,n];
%vanishingPoint = [1156,910];

% loading data
close all
fileDir = fullfile(dataDir(),road,year,'target_data_road_height_12_03.csv');
dataTable1 = readtable(fileDir);
fileDir = fullfile(dataDir(),road,year,'target_data_road_height_06_03.csv');
dataTable2 = readtable(fileDir);
fileDir = fullfile(dataDir(),road,year,'target_data_road_height_01_03.csv');
dataTable3 = readtable(fileDir);
%data = [dataTable1;dataTable2;dataTable3];
data = [dataTable2;dataTable3];

data.file = data.image_file;

% splitting into train and test sets
split = 1; % percentage to train on. 
nData = size(data,1);
nTrain = ceil(nData*split);
%shuffle data and split
data = data(randperm(nData),:);
dataTrain = data(1:nTrain,:);
dataTest = data(nTrain+1:end,:);

%% Training (Calibrating)
coords = [dataTrain.x,dataTrain.y,dataTrain.z,dataTrain.u,dataTrain.v];

alphaInit = 0; alphaLB = -0.2; alphaUB = 0.2;
betaInit = 0; betaLB = -0.2; betaUB = 0.2;
gammaInit = 0; gammaLB = -0.2; gammaUB = 0.2;
x0Init = 2; x0LB = 2; x0UB = 2;
y0Init = 0; y0LB = 0; y0UB = 0;
hInit = 3; hLB = 1; hUB = 4;
fInit = 4000; fLB = 4000; fUB = 4000;
% fInit = 1/4000; fLB = 0; fUB = 0.0005;
% cuInit = 0; cuLB = -1000; cuUB = 1000;
% cvInit = 0; cvLB = -1000; cvUB = 1000;
% k1Int = 0; k1LB =  0; k1UB = 0;
% p1Int = 0; p1LB =  0; p1UB = 0;

% creating initial guess and bounds vectors
% thetaInit = [alphaInit, betaInit, gammaInit, x0Init, y0Init, hInit, fInit, fInit, cuInit, cvInit, k1Int, p1Int];
% thetaLB = [alphaLB, betaLB, gammaLB, x0LB, y0LB, hLB, fLB, fLB, cuLB, cvLB, k1LB, p1LB];
% thetaUB = [alphaUB, betaUB, gammaUB, x0UB, y0UB, hUB, fUB, fUB, cuUB, cvUB, k1UB, p1UB];
% SIMPLE
thetaInit = [alphaInit, betaInit, gammaInit, x0Init, y0Init, hInit, fInit];
thetaLB = [alphaLB, betaLB, gammaLB, x0LB, y0LB, hLB, fLB];
thetaUB = [alphaUB, betaUB, gammaUB, x0UB, y0UB, hUB, fUB];

% objective function and initial estimate
f = @(theta) cameraEquationFunction(theta,coords,systemParams);

disp('Running Global search')
options = optimset('TolFun',1e-16,'TolX',1e-16);
problem = createOptimProblem('fmincon','objective',f,'x0',thetaInit,'lb',thetaLB,'ub',thetaUB,'options',options);
ms = MultiStart;
[xg,fg,flg,og] = run(ms,problem,10);

thetaSolve = xg;
fval = fg;
%% results
show_results = true;
if show_results
    % exts
    alpha = thetaSolve(1); beta = thetaSolve(2); gamma = thetaSolve(3);
    x0 = thetaSolve(4); y0 = thetaSolve(5);  h = thetaSolve(6); 
    % ints
    fu = thetaSolve(7); fv = thetaSolve(7);
%     cu = thetaSolve(9); cv = thetaSolve(10);
%     k1 = thetaSolve(11); p1 = thetaSolve(12);

    fprintf('Solved with train error: %f pixels \n',fval);
    fprintf('--------Extrinsic Parameters---------\n')
    fprintf(' alpha (roll) : %2.4f degs \n beta (tilt) : %2.4f degs \n gamma (pan) : %2.4f degs\n', rad2deg(alpha), rad2deg(beta), rad2deg(gamma));
    fprintf(' h : %2.4f m  \n x0 : %2.4f m  \n y0 : %2.4f m \n', h, x0, y0)
    fprintf('--------Intrinsic Parameters---------\n')
    fprintf(' fu : %2.9f \n', fu);
    fprintf(' fv : %2.9f \n', fv);
%     fprintf(' cu : %2.2f \n', cu);
%     fprintf(' cv : %2.2f \n', cv);
%     fprintf(' k1 : %2.8f \n', k1);
%     fprintf(' p1 : %2.8f \n', p1);
%     
    % find the road surface and the test point
    %findRoad(thetaSolve,systemParams,road,year);
    %figure
    %findTargets(dataTrain,thetaSolve,systemParams); 
    exploreError(coords,thetaSolve,systemParams)
end


%% saving
save = false;
if save
%    roll = Alpha; tilt = Beta; pan = Gamma;
   calibration_parameters = table(alpha,beta,gamma,x0,y0,h,m,n,fu,fv);
   out_file = fullfile(dataDir(),road,year,'calibration_parameters_simple.csv');
   writetable(calibration_parameters,out_file,'QuoteStrings',true); 
   disp('saved camera parameters')
end