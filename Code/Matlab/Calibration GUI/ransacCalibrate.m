function thetaSolve = ransacCalibrate(data,cameraParams)

systemParams = [cameraParams.m,cameraParams.n];
data = table2array(data(:,{'x','y','z','u','v'}));

%% ransac
% defining ransac fitting function and distance function
fitThetaFnc = @(dataPoints) solveCameraEquation(data,systemParams);
distFcn = @(theta,dataPoints) comparePixels(theta,data,systemParams);
[thetaSolve, inlierIdx] = ransac(data,fitThetaFnc,distFcn,8,75);
inlierIdx
%% results
alpha = thetaSolve(1); beta = thetaSolve(2); gamma = thetaSolve(3);
x0 = thetaSolve(4); y0 = thetaSolve(5);  h = thetaSolve(6); 
% ints
fu = thetaSolve(7); fv = thetaSolve(7);

%fprintf('Solved with train error: %f pixels \n',fval);
fprintf('--------Extrinsic Parameters---------\n')
fprintf(' alpha (roll) : %2.4f degs (%2.4f rads) \n beta (tilt) : %2.4f degs (%2.4f rads) \n gamma (pan) : %2.4f degs (%2.4f rads) \n', ...
    rad2deg(alpha), alpha, rad2deg(beta), beta, rad2deg(gamma), gamma);
fprintf(' h : %2.4f m  \n x0 : %2.4f m  \n y0 : %2.4f m \n', h, x0, y0)
fprintf('--------Intrinsic Parameters---------\n')
fprintf(' fu : %2.4f \n', fu);
fprintf(' fv : %2.4f \n', fv);

thetaSolve = [alpha, beta, gamma, x0, y0, h, fu, fv, 0,0, cameraParams.m, cameraParams.n];

end


function distances = comparePixels(theta,dataPoints,systemParams)
    
    params.alpha = theta(1); params.beta = theta(2); params.gamma = theta(3);
    params.x0 = theta(4); params.y0 = theta(5); params.h = theta(6);
    params.fu = theta(7); params.fv = theta(7);
    params.m = systemParams(1); params.n = systemParams(2);
    
    x = dataPoints(:,1);
    y = dataPoints(:,2);
    z = dataPoints(:,3);
    u = dataPoints(:,4);
    v = dataPoints(:,5);
    
    numDataPoints = size(dataPoints,1);
    for iData = 1:numDataPoints
        [u_model(iData), v_model(iData)] = ...
            getPixelsFromCoords([x(iData),y(iData),z(iData)]', params);
        distances(iData) = ...
            sqrt((u(iData)-u_model(iData))^2 + (v(iData)-v_model(iData))^2);
    end
    norm(distances)
end

function thetaSolve = solveCameraEquation(dataPoints,systemParams)
   
    x = dataPoints(:,1);
    y = dataPoints(:,2);
    z = dataPoints(:,3);
    u = dataPoints(:,4);
    v = dataPoints(:,5);

    coords = [x,y,z,u,v];

    % objective function and initial estimate
    f = @(theta) simpleCameraFunction(theta,coords,systemParams,[]);
    thetaInit = [0,0,0,0,0,2,4000];
         %  a  b    g   x0  y0   h  fu
    ub = [  0, 0.2, 0.2,   0,  1,  5,  7000];
    lb = [ -0,-0.2, -0.2,   0, -1,  1,  1000];
    
    disp('Running Global search')
    problem = createOptimProblem('fmincon','objective',f,'x0',thetaInit,'lb',lb,'ub',ub);
    ms = MultiStart;
    [thetaSolve,fval,flg,og] = run(ms,problem,1);

end
