function thetaSolve = calibrate(data,cameraParams)
% CALIBRATE calibrates simple pinhole camera model by minising the
% reprojection error between the computed pixels of x,y,z coords and u,v
% pixels in data. Currently the cameraParams argument is not used

coords = [data.x,data.y,data.z,data.u,data.v];
systemParams = [cameraParams.m,cameraParams.n];

vanishingPoint = [];
% function to be minimised
f = @(theta) simpleCameraFunction(theta,coords,systemParams,vanishingPoint);
% initial values and constraints
           % alpha beta  gamma x0  y0    h      f
thetaInit = [0,     0,     0,   0,   0,   2.5,    5000];
ub = [       0,   0.2,    0.1,  0,   2,   2.8,    8000];
lb = [      -0, -0.2,    -0.1,  0,  -2,   2.3,    1000];
% constraint function
vanishingPoint = [1127,937];
%nonlcon = @(theta) calibrationConstraints(theta,systemParams,vanishingPoint);

% solver options and set up the global solver
% options = optimset('TolFun',1e-10,'TolX',1e-10);
% problem = createOptimProblem('fmincon','objective',f,'x0',...
%     thetaInit,'lb',lb,'ub',ub,'nonlcon',constraints,'options',options);
% ms = MultiStart;
% % run
% [thetaSolve,fval,flag] = run(ms,problem,5);
[thetaSolve,fval,flag] = fmincon(f,thetaInit,[],[],[],[],lb,ub);
% explore the error gradients of each of the parameters. 
%exploreError(coords,thetaSolve,systemParams)

%% results
alpha = thetaSolve(1); beta = thetaSolve(2); gamma = thetaSolve(3);
x0 = thetaSolve(4); y0 = thetaSolve(5);  h = thetaSolve(6); 
% ints
fu = thetaSolve(7); fv = thetaSolve(7);

fprintf('Solved with train error: %f pixels \n',fval);
fprintf('--------Extrinsic Parameters---------\n')
fprintf(' alpha (roll) : %2.4f degs (%2.4f rads) \n beta (tilt) : %2.4f degs (%2.4f rads) \n gamma (pan) : %2.4f degs (%2.4f rads) \n', ...
    rad2deg(alpha), alpha, rad2deg(beta), beta, rad2deg(gamma), gamma);
fprintf(' h : %2.4f m  \n x0 : %2.4f m  \n y0 : %2.4f m \n', h, x0, y0)
fprintf('--------Intrinsic Parameters---------\n')
fprintf(' fu : %2.8f \n', fu);
fprintf(' fv : %2.8f \n', fv);
%figure
%findTargetsSimpleCamera(data,thetaSolve,systemParams);
cu = 0; cv = 0;
thetaSolve = [alpha, beta, gamma, x0, y0, h, fu, fv, cu, cv, cameraParams.m, cameraParams.n];