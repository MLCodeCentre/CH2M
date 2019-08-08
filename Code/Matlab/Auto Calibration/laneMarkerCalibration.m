function cameraParams = laneMarkerCalibration(road,image,nMarkers)
close all
fileName = fullfile(dataDir(),road,'Images',image);

%[vanishingPoint,laneMarkers] = getVanishingPointAndLaneMarkers(fileName);

figure 
img = imread(fileName);
imshow(img)

% % first click on vanishing point then the 3 lane markers
%[U,V] = ginput(2*nMarkers);
%pixels = array2table([vanishingPoint(1),vanishingPoint(2);round(U),round(V)], 'VariableNames', {'u','v'});
%writetable(pixels,'laneMarkerPixels.csv')
pixels = readtable('laneMarkerPixels.csv');

% initiating objective function
cameraParams.cu = 0; cameraParams.cv = 0;
cameraParams.p1 = 0; cameraParams.p2 = 0;
cameraParams.k1 = 0; cameraParams.k2 = 0;
cameraParams.s = 0;
cameraParams.m = size(img,1); cameraParams.n = size(img,2);

cameraParams.alpha = 0; cameraParams.beta = 0; cameraParams.gamma = 0;
cameraParams.x0 = 0; cameraParams.y0 = 0; cameraParams.h = 3;
cameraParams.xm = 0; cameraParams.ym = 0; cameraParams.separation = 3;
cameraParams.laneMarkerLength = 5;

cameraParams.fu = 5000; cameraParams.fv = 5000;

for itter = 1
    %% Extrinsics
    fExtrinsics = @(theta) laneMarkerCameraFunctionExtrinsics(theta,cameraParams,pixels);
    
    thetaExtInit = [cameraParams.alpha, cameraParams.beta, cameraParams.gamma, ...
        cameraParams.x0, cameraParams.y0, cameraParams.h, cameraParams.xm,cameraParams.ym, ...
        cameraParams.separation, cameraParams.laneMarkerLength]; 
    % EXTRINSICS   [alpha, beta, gamma, x0,   y0,   h, xm, ym, sep, markerLength]
    thetaExtUB =   [  0,   0.2,   0.5,  4,   0.5,   4,  8,  6,  10,  5];
    thetaExtLB =   [ -0,  -0.2,  -0.5,  0,  -0.5, 1.0,  2,  1,   1,  1];

    % solving
    disp('Running Global search')
    options = optimset('TolFun',1e-16,'TolX',1e-16);
    problem = createOptimProblem('fmincon','objective',fExtrinsics,...
        'x0',thetaExtInit,'lb',thetaExtLB,'ub',thetaExtUB,'options',options);
    ms = MultiStart;
    [thetaSolve,fval,flag] = run(ms,problem,3);

    % results
    cameraParams.alpha = thetaSolve(1); cameraParams.beta = thetaSolve(2); cameraParams.gamma = thetaSolve(3);
    cameraParams.x0 = thetaSolve(4); cameraParams.y0 = thetaSolve(5); cameraParams.h = thetaSolve(6);
    cameraParams.xm = thetaSolve(7); cameraParams.ym = thetaSolve(8);
    cameraParams.separation = thetaSolve(9); cameraParams.laneMarkerLength = thetaSolve(10);

    %fu = thetaSolve(11); fv = thetaSolve(12);

    fprintf('Solved with error: %f pixels \n',fval);
    fprintf('--------Extrinsic Parameters---------\n')
    fprintf(' alpha (roll) : %2.4f degs \n beta (tilt) : %2.4f degs \n gamma (pan) : %2.4f degs\n',...
        rad2deg(cameraParams.alpha), rad2deg(cameraParams.beta), rad2deg(cameraParams.gamma));
    fprintf(' h : %2.4f m  \n x0 : %2.4f m  \n y0 : %2.4f m \n', cameraParams.h, cameraParams.x0, cameraParams.y0)
    fprintf(' xm : %2.4f m  \n ym : %2.4f m  \n', cameraParams.xm, cameraParams.ym)
    fprintf(' marker separation: %2.4f m \n', cameraParams.separation)
    fprintf(' marker length: %2.4f m \n', cameraParams.laneMarkerLength)

    %% Intrisics
    fIntrinsics = @(theta) laneMarkerCameraFunctionIntrinsics(theta,cameraParams,pixels);
    % EXTRINSICS[fu, fv]
    thetaIntInit = [cameraParams.fu, cameraParams.fv]; 
    thetaIntUB =   [10000, 10000];
    thetaIntLB =   [0,     0];

    % solving
    disp('Running Global search')
    options = optimset('TolFun',1e-16,'TolX',1e-16);
    problem = createOptimProblem('fmincon','objective',fIntrinsics,...
        'x0',thetaIntInit,'lb',thetaIntLB,'ub',thetaIntUB,'options',options);
    ms = MultiStart;
    [thetaSolve,fval,flag] = run(ms,problem,3);

    %results
    cameraParams.fu = thetaSolve(1); cameraParams.fv = thetaSolve(2);
    fprintf('--------Intrinsic Parameters---------\n')
    fprintf(' fu : %2.4f \n', cameraParams.fu);
    fprintf(' fv : %2.4f \n', cameraParams.fv);

end
%%
hold on
xRange = linspace(5,50,10);
yRange = linspace(-2,2,4);
zRange = 0;

for x = xRange
    for y = yRange
        for z = zRange
            [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
            plot(u,v,'ro')
        end
    end
end

laneMarkerPixels = pixels(2:end,:);

for iMarker = 1:nMarkers
   plot(laneMarkerPixels(2*iMarker - 1,:).u,laneMarkerPixels(2*iMarker - 1,:).v,'k+')
   x = cameraParams.xm + (iMarker-1)*cameraParams.separation; y=cameraParams.ym; z=0;
   [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
            plot(u,v,'bo')
   plot(laneMarkerPixels(2*iMarker,:).u,laneMarkerPixels(2*iMarker,:).v,'k+')
   x = cameraParams.xm + (iMarker-1)*cameraParams.separation + cameraParams.laneMarkerLength; y=cameraParams.ym; z=0;
   [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
            plot(u,v,'bo')
end
