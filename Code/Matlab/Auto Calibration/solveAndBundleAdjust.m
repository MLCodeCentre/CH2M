close all
% load data.
imageCoords_load = load('C:\Users\ts1454\Projects\Jacobs\Code\Matlab\Auto Calibration\Correspondences\M69_imageCoords.mat');
trackedPoints_load = load('C:\Users\ts1454\Projects\Jacobs\Code\Matlab\Auto Calibration\Correspondences\M69_trackedPoints.mat');
imageCoords = imageCoords_load.imageCoords;
% images
nImages = 3;
headings = imageCoords(1:nImages,3);
imageCoords = imageCoords(1:nImages,1:2);
% pixels
pixels = trackedPoints_load.trackedPoints;
nPixels = 100;
pixels = pixels(:,1:nPixels,:);
% reformat image coords so everything is relative to the first image.
imageCoords = imageCoords - imageCoords(1,:);

%% first im going to fix the camera parameters to get and estimation of the pixel 3D coords.
cameraParams = 4000; % fu, fv, cu, cv;
% assume rotation and translation is purely the vehicle from GPS. 

% these are the camera rotations. 
rotations = [0*ones(nImages,1), -5*ones(nImages,1), headings];
% the translations are just relative to the first image. 
translations = [imageCoords, zeros(nImages,1)];
% now we make some guess for all the points.
pixels3D = [randomNumbers(40,100,nPixels), randomNumbers(-10,10,nPixels), randomNumbers(0,5,nPixels)];
% display initial error
[fvalInit, errorInit] = reprojectionFunction(pixels,cameraParams,pixels3D,rotations,...
    translations,nPixels,nImages);
fprintf('Initial reprojection error: %2.2f [pixels]\n',fvalInit);
fprintf('+--------------------------------------+\n')

%% lets try to fix the coords of the pixels
options = optimoptions('fmincon','MaxFunctionEvaluations',10e+5,'MaxIterations',150);
minPixels3DFunc = @(pixels3D) reprojectionFunction(pixels,cameraParams,pixels3D,...
    rotations,translations,nPixels,nImages);
fprintf('Optimising 3D pixel coordinates...\n')
%[pixels3DAdj,fvalPixel] = fmincon(minPixels3DFunc,pixels3D,[],[],[],[],[],[],[],options);
fprintf('finished, reprojection error: %2.2f [pixels]\n', fvalPixel);
fprintf('+--------------------------------------+\n')

%% and now the rotations
minRotationsFunc = @(rotations) reprojectionFunction(pixels,cameraParams,pixels3DAdj,...
    rotations,translations,nPixels,nImages);
fprintf('Optimising rotations...\n')
%[rotationsAdj,fvalRotations] = fmincon(minRotationsFunc,rotations,[],[],[],[],[],[],[],options);
fprintf('finished, reprojection error: %2.2f [pixels]\n', fvalRotations);
fprintf('+--------------------------------------+\n')

%% finally the cameraParams this will be a global optmisation
minCameraParamsFunc = @(cameraParams) reprojectionFunction(pixels,cameraParams,...
    pixels3DAdj,rotationsAdj,translations,nPixels,nImages);
options = optimoptions('fmincon','MaxFunctionEvaluations',10e+5,...
    'MaxIterations',150,'StepTolerance',1e-16);
problem = createOptimProblem('fmincon','objective',minCameraParamsFunc,...
    'x0',cameraParams,...
    'lb',[1000],...    
    'ub',[6000],...
    'options',options);
gs = GlobalSearch;
fprintf('Optimising camera parameters...\n')
%[cameraParamsAdj,fvalCameraParams] = run(gs,problem);
fprintf('finished, reprojection error: %2.2f [pixels]\n', fvalCameraParams);
fprintf('+--------------------------------------+\n')

%% lets compare all errors.
[fvalAdj, errorAdj] = reprojectionFunction(pixels,cameraParamsAdj,pixels3DAdj,rotationsAdj,...
    translations,nPixels,nImages);

plot(errorInit); hold on; plot(errorAdj);
title('Reprojection error before and after first adjustments');
xlabel(sprintf('tracked pixel (%d per image)',nPixels))
ylabel('Reprojection error [pixels]');
legend({'Before adjustment','After adjustment'})

fprintf('Camera parameters after initial adjustment:\n\t')
% fprintf('f: %2.2f, cu: %2.2f, cv: %2.2f\n', cameraParamsAdj(1), ...
%     cameraParamsAdj(2), cameraParamsAdj(3))
fprintf('f: %2.2f [pixels]\n', cameraParamsAdj(1));
fprintf('Reprojection error after initial adjustment:\n\t%2.2f [pixels]\n', fvalAdj);
fprintf('+--------------------------------------+\n')

%% complete bundle adjustment
% create theta that contains adjusted cameraParams, pixelCoords and rotations.
theta = [cameraParamsAdj, pixels3DAdj(:)', rotationsAdj(:)'];
bundleAdjustFunc = @(theta) bundleAdjustment(theta,pixels,translations,nPixels,nImages);
options = optimoptions('fmincon','MaxFunctionEvaluations',10e+5,'Display','iter','MaxIterations',500);
problem = createOptimProblem('fmincon','objective',bundleAdjustFunc,...
    'x0',theta,'options',options);
gs = GlobalSearch;
fprintf('Optimising camera parameters...\n')
%[thetaAdj,fvalCameraParams] = run(gs,problem);

fprintf('finished, reprojection error: %2.2f [pixels]\n', fvalBundle);
% unpack theta again
[cameraParamsBA, pixel3DBA, rotationsBA] = unpackTheta(thetaAdj,nPixels,nImages);
fprintf('Camera parameters after initial adjustment:\n\t')
% fprintf('f: %2.2f, cu: %2.2f, cv: %2.2f\n', cameraParamsAdj(1), ...
%     cameraParamsAdj(2), cameraParamsAdj(3))
fprintf('f: %2.2f [pixels]\n', cameraParamsBA(1));
fprintf('+--------------------------------------+\n')

%% plot
figure; hold on; xlabel('x'); ylabel('y'); zlabel('z');
for iImage = 1:nImages
    Location = translations(iImage,:);
    alpha = rotationsBA(iImage,1); beta = rotationsBA(iImage,2); gamma = rotationsBA(iImage,3);
    R = rotationMatrix(alpha, beta, gamma);
    cam = plotCamera('Location',Location,'Orientation',R,'Opacity',0.1,'Size',0.3);
end
for iPixel = 1:nPixels
   x = pixels3D(iPixel,1); y = pixels3D(iPixel,2); z = pixels3D(iPixel,3);
   plot3(x,y,z,'*') 
end


