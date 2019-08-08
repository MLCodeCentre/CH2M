function sequentialFeatureTracking(road,PCDATE,PCTIMES)
    close all
    i = 1;
    nPCTIMES = length(PCTIMES);
    for iPCTIME = 1:nPCTIMES-1
        
        I1 = rgb2gray(imread(fullfile(dataDir,road,'Images',sprintf('2_%d_%d.jpg',PCDATE,PCTIMES(iPCTIME)))));
        I2 = rgb2gray(imread(fullfile(dataDir,road,'Images',sprintf('2_%d_%d.jpg',PCDATE,PCTIMES(iPCTIME+1)))));
        
        points1 = detectKAZEFeatures(I1);
        points2 = detectKAZEFeatures(I2);
        
        [f1,vpts1] = extractFeatures(I1,points1);
        [f2,vpts2] = extractFeatures(I2,points2);
        
        indexPairs = matchFeatures(f1,f2,'MatchThreshold',8,'MaxRatio',0.2) ;
        matchedPoints1 = vpts1(indexPairs(:,1));
        matchedPoints2 = vpts2(indexPairs(:,2));
        
        figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
        legend('matched points 1','matched points 2');
        
        fRANSAC=estimateFundamentalMatrix(matchedPoints1,matchedPoints2,...
       'Method', 'MSAC', 'NumTrials', 2000, 'DistanceThreshold', 1e-2)
        
        fundamentalMatrixNPoints(i,:,:) = [fRANSAC, [size(matchedPoints1,1);1;1]];
        issymmetric(fRANSAC,'skew') 
        i = i + 1
    end
    save(sprintf('Correspondences/%sFundamentalMatricesandNPoints',road),'fundamentalMatrixNPoints')
end
