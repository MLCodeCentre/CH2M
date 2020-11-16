close all

road = 'A43';

nPoints = 100;

I1 = rgb2gray(imread(fullfile(dataDir,road,'Images','2_1221_19201.jpg')));
I2 = rgb2gray(imread(fullfile(dataDir,road,'Images','2_1221_19202.jpg')));

[n,m] = size(I1);
%I1 = imcrop(I1,[0,0.4*n,m,n]);
%I2 = imcrop(I2,[0,0.4*n,m,n]);


%figure(1); imshow(I1); figure(2); imshow(I2); figure(3); imshow(I3);

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

[indexPairs,matchmetric] = matchFeatures(f1,f2,'MaxRatio',1);

% indexPairs = indexPairs(1:min(nMatches,500),:);
% matchedPoints1 = vpts1(indexPairs(:,1));
% matchedPoints2 = vpts2(indexPairs(:,2));

% dists = matchedPoints1.Location - matchedPoints2.Location;
% eucDist = sqrt(dists(:,1).^2 + dists(:,2).^2);
% matchedPoints1 = matchedPoints1(eucDist<100);
% matchedPoints2 = matchedPoints2(eucDist<50);


[tform,matchedPoints1,matchedPoints2] = ...
    estimateGeometricTransform(matchedPoints1,matchedPoints2,...
    'similarity');
figure; 
nMatches = size(matchedPoints1,1)

figure; ax = axes; 
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2)%,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

F = estimateFundamentalMatrix(matchedPoints1,matchedPoints2)
cameraParams0 = [4000,0,0];
f = @(cameraParams) mendocaFunction(cameraParams, F, nMatches, nMatches)
fmincon(f, cameraParams0)

function fval = mendocaFunction(cameraParams, F, nMatches, totalMatches)
    fu = cameraParams(1); %fv = cameraParams(2);
    cu = cameraParams(2); cv = cameraParams(3);
    K = [fu 0 cu; 0 fu cv; 0 0 1];
    [U,S,V] = svd(K'*F*K);
    fval = (nMatches/totalMatches)*((S(1,1) - S(2,2))/S(2,2))
end