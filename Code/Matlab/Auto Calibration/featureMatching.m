close all

road = 'A43';

nPoints = 100;

I1 = rgb2gray(imread(fullfile(dataDir,road,'Images','2_1221_19201.jpg')));
I2 = rgb2gray(imread(fullfile(dataDir,road,'Images','2_1221_19202.jpg')));

[n,m] = size(I1);
I1 = imcrop(I1,[0,0.4*n,m,n]);
I2 = imcrop(I2,[0,0.4*n,m,n]);


%figure(1); imshow(I1); figure(2); imshow(I2); figure(3); imshow(I3);

points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

[indexPairs,matchmetric] = matchFeatures(f1,f2,'MaxRatio',1);
nMatches = size(indexPairs,1)
indexPairs = indexPairs(1:min(nMatches,50),:);
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

dists = matchedPoints1.Location - matchedPoints2.Location;
eucDist = sqrt(dists(:,1).^2 + dists(:,2).^2);
matchedPoints1 = matchedPoints1(eucDist<100);
matchedPoints2 = matchedPoints2(eucDist<100);


figure; ax = axes; 
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2)%,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');



function roiImg = getROI(img,xbuff,ybuff)
    % find region of interest - the road surface. Creates a trapezium from
    % the bottom corners of the image to 2 pinched corners ybuff from the
    % top of the image and xbuff from the side.
    
    m = size(img,2); n = size(img,1);
    % corners of the trapezium
    tl = [0+xbuff,0+ybuff]; tr = [m-xbuff,0+ybuff];
    bl = [0,n]; br = [m,n];
    
    % creating mask and applying
    x = [tl(1), tr(1), br(1), bl(1)];
    y = [tl(2), tr(2), br(2), bl(2)];   
    mask = poly2mask(x,y,n,m);
    roiImg = bsxfun(@times, img, cast(mask, 'like', img));
    
end