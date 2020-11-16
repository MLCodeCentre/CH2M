function sequentialFeatureTracking(road,navFile,PCDATE,PCTIMES)
    close all
    nPCTIMES = length(PCTIMES);
    C = []; D = [];
    for iPCTIME = 1:nPCTIMES-1
        
        nav1 = navFile(navFile.PCDATE==PCDATE & navFile.PCTIME==PCTIMES(iPCTIME),:);
        nav2 = navFile(navFile.PCDATE==PCDATE & navFile.PCTIME==PCTIMES(iPCTIME+1),:);
        delta_t(:,iPCTIME) = [0.005; nav2.YCOORD - nav1.YCOORD; nav2.XCOORD - nav1.XCOORD];
        
        I1 = rgb2gray(imread(fullfile(dataDir,road,'Images',sprintf('2_%d_%d.jpg',PCDATE,PCTIMES(iPCTIME)))));
        I2 = rgb2gray(imread(fullfile(dataDir,road,'Images',sprintf('2_%d_%d.jpg',PCDATE,PCTIMES(iPCTIME+1)))));
        
        points1 = detectSURFFeatures(I1);
        points2 = detectSURFFeatures(I2);
        
        [n,m] = size(I1);
        
        [f1,vpts1] = extractFeatures(I1,points1);
        [f2,vpts2] = extractFeatures(I2,points2);
        
        indexPairs = matchFeatures(f1,f2,'MatchThreshold',8,'MaxRatio',0.2);
        matchedPoints1 = vpts1(indexPairs(:,1));
        matchedPoints2 = vpts2(indexPairs(:,2));
        
        figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
        legend('matched points 1','matched points 2');
        
        [fRANSAC,inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,...
        'Method', 'MSAC', 'NumTrials', 2000, 'DistanceThreshold', 1e-2);
        
        fundamentalMatrixNPoints(iPCTIME,:,:) = [fRANSAC, [size(matchedPoints1,1);1;1]];
        issymmetric(fRANSAC,'skew')
        
        epiLines = epipolarLine(fRANSAC',matchedPoints2(inliers,:).Location);
        A = epiLines(:,1:2); B = -epiLines(:,3);
        epipole = A\B;
        hold on
        plot(epipole(1),epipole(2),'m+','MarkerSize',14)  
        epipole(1) = epipole(1) - m/2;
        epipole(2) = -epipole(2) + n/2;
        
        C = [C; delta_t(:,iPCTIME)' 0 0 0; 0 0 0 delta_t(:,iPCTIME)']; 
        D = [D; -epipole(1).* delta_t(:,iPCTIME)'; -epipole(2).*delta_t(:,iPCTIME)'];       
        
    end

    E = D'*D - D'*C*(inv(C'*C))*C'*D;
    [EigVecs,Eigs] = eig(E);
    
    z = EigVecs(:,diag(Eigs) == min(diag(Eigs))');
    y = -inv(C'*C)*C'*D*z;
    f = [y(1:3),y(4:6),z]'
    [R,H] = qr(f)
    %save(sprintf('Correspondences/%sFundamentalMatricesandNPoints',road),'fundamentalMatrixNPoints')
end
