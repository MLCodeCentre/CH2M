function registerImages(ref_img, query_img)

ref_img = rgb2gray(ref_img);
query_img = rgb2gray(query_img);

level = 0.9

ref_img = im2bw(ref_img,level);
query_img = im2bw(query_img,level);

% detect features in both images
ptsRef  = detectSURFFeatures(ref_img);
ptsQuery = detectSURFFeatures(query_img);

% Extract feature descriptors
[featuresRef,  validPtsRef]  = extractFeatures(ref_img,  ptsRef);
[featuresQuery, validPtsQuery] = extractFeatures(query_img, ptsQuery);

% Match features by their descriptors
indexPairs = matchFeatures(featuresRef, featuresQuery);

% Retrieve locations of corresponding points for each image.
matchedRef  = validPtsRef(indexPairs(:,1));
matchedQuery = validPtsQuery(indexPairs(:,2));

figure;
showMatchedFeatures(ref_img,query_img,matchedRef,matchedQuery);
title('Putatively matched points (including outliers)');