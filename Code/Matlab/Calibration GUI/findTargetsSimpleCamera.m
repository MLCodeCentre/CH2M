function findTargetsSimpleCamera(dataPoints,theta,systemParams)   
    % extrinsics
    params.alpha = theta(1); params.beta = theta(2); params.gamma = theta(3);
    params.x0 = theta(4); params.y0 = theta(5); params.h = theta(6);

    % intrinsics
    params.fu = theta(7); params.fv = theta(7);
    params.cu = theta(8); params.cv = theta(9);
    %radial 
    params.k1 = 0; params.k2 = 0;
    % tangential
    params.p1 = 0; params.p2 = 0;
    params.s = 0;
    
    params.m = systemParams(1); params.n = systemParams(2);
    dataPoints = sortrows(dataPoints,'file');
    
    nData = size(dataPoints,1);
    currentImageFile = '';
    iImage = 1;
    nImages = length(unique(dataPoints.file));
    
    
    for iData = 1:nData
       imageFile = dataPoints(iData,:).file;
       if strcmp(currentImageFile,imageFile{1}) == 0
            subplot(ceil(nImages/2),2,iImage)
            %figure
            I = imread(imageFile{1});
            currentImageFile = imageFile{1};
            imshow(I);
            %title(image_file)
            hold on
            iImage = iImage + 1;
            dataLabel = 1;
       end
        
       dataPoint = dataPoints(iData,:);     
       plot(dataPoint.u, dataPoint.v, 'k+')
       [u,v] = getPixelsFromCoords([dataPoint.x,dataPoint.y,dataPoint.z]',params);
       error(iData) = sqrt((u-dataPoint.u)^2 + (v-dataPoint.v)^2);
       plot(u,v,'ro');
       text(u,v,sprintf('%d',dataLabel),'color','g')
       dataLabel = dataLabel + 1;

    end
    figure;
    I = imread(imageFile{1});
    currentImageFile = imageFile{1};
    imshow(I); hold on;
    U = [];
    V = [];
    z = 0;
    for x = linspace(10,40,10)
        for y = linspace(-1.8,1.8,10)        
            [u,v] = getPixelsFromCoords([x,y,z]',params);
            U = [U,u];
            V = [V,v];
        end
        plot(U(:),V(:),'bo')
        hold on
        U = [];
        V = [];
    end
    
    testError = norm(error);
    avgTestError = testError/nData;
    fprintf('Test error: %f pixels \n',testError);
    fprintf('Average test error: %f pixels \n',avgTestError);
    
end