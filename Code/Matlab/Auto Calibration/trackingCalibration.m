function trackingCalibration(trackedPoints,trackedCoords,road,PCDATE,PCTIMES)
    close all
    m = 2464; n = 2056;
    imageInds = [7,8];
    trackedPoints = trackedPoints(imageInds,1:50,:);
    trackedCoords = trackedCoords(imageInds,:);

    nImages = size(trackedPoints,1);
    nPoints = size(trackedPoints,2);
    
    % first try a function that takes in all points

    fprintf('%d equations to solve %d unknowns\n',nImages*nPoints*2,10+2*nPoints)

    % initial guesses and UB/LB for camera parameters.
    alphaInit = 0; alphaLB = -0.2; alphaUB = 0.2;
    betaInit = 0; betaLB = -0.2; betaUB = 0.2;
    gammaInit = 0; gammaLB = -0.2; gammaUB = 0.2;
    x0Init = 2; x0LB = 0; x0UB = 4;
    y0Init = 0; y0LB =  -1; y0UB = 1;
    hInit = 2; hLB = 0; hUB = 3;
    fInit = 4000; fLB = 1000; fUB = 8000;
    cuInit = 0; cuLB = -2000; cuUB = 2000;
    cvInit = 0; cvLB = -2000; cvUB = 2000;
    % initial guesses for point coordinates.
    yInit = 0; yLB = -2; yUB = 2;
    zInit = 2; zLB = 0; zUB = 4;

    % creating initial guess and bounds vectors
    thetaInit = [alphaInit, betaInit, gammaInit, x0Init, y0Init, hInit, fInit, cuInit, cvInit];
    thetaLB = [alphaLB, betaLB, gammaLB, x0LB, y0LB, hLB, fLB, cuLB, cvLB];
    thetaUB = [alphaUB, betaUB, gammaUB, x0UB, y0UB, hUB, fUB, cuUB, cvUB];

    for iPoint = 1:nPoints
       thetaInit = [thetaInit, yInit, zInit];
       thetaLB = [thetaLB, yLB, zLB];
       thetaUB = [thetaUB, yUB, zUB];
    end

    f = @(theta) trackingCameraFunction(theta,trackedPoints,trackedCoords);
    disp('Running Global search')
    options = optimset('TolFun',1e-16,'TolX',1e-16,...
        'MaxFunEvals',5000,'MaxIter',5000,'Display','Iter');
    problem = createOptimProblem('fmincon','objective',f,'x0',thetaInit,'lb',thetaLB,'ub',thetaUB,'options',options);
    ms = MultiStart;
    [thetaSolve,fg,flg,og] = run(ms,problem,5);

    cameraParams = [thetaSolve(1:9),m,n]
    pointsYZ = thetaSolve(9:end);
    [~,reprojections] = f(thetaSolve);
    %image = fullfile(dataDir(),road,'Images',sprintf('2_%d_%d.jpg',PCDATE,PCTIMES(imageInds(iImage))));
    %plotReprojectionError(reshape(trackedPoints(iImage,:,:),nPoints,2),reprojections,image);
    %plotRoadSurface(cameraParams,fullfile(dataDir,'A52','Images','2_1040_4482.jpg'));

    % bundleAdjust
    g = @(pointsYZ) myBundleAdjustment(pointsYZ,trackedCoords,trackedPoints,cameraParams);
    options = optimset('TolFun',1e-16,'TolX',1e-16,...
        'MaxFunEvals',500,'MaxIter',500,'Display','Iter');
    problem = createOptimProblem('fmincon','objective',g,'x0',pointsYZ);
    ms = MultiStart;
    [pointsYZAdjusted,fg,flg,og] = run(ms,problem,2);
    thetaInit = [cameraParams,pointsYZAdjusted]
end

 
