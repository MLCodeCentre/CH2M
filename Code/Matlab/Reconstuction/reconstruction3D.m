function reconstruction3D
% load camera Parameters
cameraParams = cameraIntrinsics([4640,4640],[2464/2,2056/2],[2464,2056]);
% load to views of a signpost
I1 = loadImage('M69',2,960,948);
mask_load = load('2_960_948.mat');
mask = uint8(mask_load.mask);
% resize mask (this is the output of the cityscapes segmentation)
mask_resized = imresize(mask, [size(I1,1), size(I1,2)], 'method', 'nearest');
imagesc(mask_resized)
% create binary mask over the signs
signs = mask_resized==7;
% imagesc(signs)
% apply mask to image
I1 = bsxfun(@times, I1, cast(signs, 'like', I1));
I2 = loadImage('M69',2,960,950);
% 
% figure
% imshowpair(I1, I2, 'montage');
% title('Undistorted Images');

%% correspsondenceS
imagePoints1 = detectHarrisFeatures(rgb2gray(I1));

% Visualize detected points
figure
imshow(I1, 'InitialMagnification', 50);
title('150 Strongest Corners from the First Image');
hold on
plot(selectStrongest(imagePoints1, 150));

% Create the point tracker
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);

% Initialize the point tracker
imagePoints1 = imagePoints1.Location;
initialize(tracker, imagePoints1, I1);

% Track the points
[imagePoints2, validIdx] = step(tracker, I2);
matchedPoints1 = imagePoints1(validIdx, :);
matchedPoints2 = imagePoints2(validIdx, :);

% Visualize correspondences
figure
showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
title('Tracked Features');

end