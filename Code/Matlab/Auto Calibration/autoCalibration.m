function autoCalibration(imageFile,navFile,assets)
    % finding correct nav file entry
    [camera,PCDATE,PCTIME] = parseImageFileName(imageFile);
    PCDATES = str2double(navFile.PCDATE);
    PCTIMES = str2double(navFile.PCTIME);
    imageInd = find((PCDATES==PCDATE & PCTIMES==PCTIME));
    image = navFile(imageInd,:);
    %% calibrating from the image
    road = 'M69';
    %cameraParams = laneMarkerCalibration(road,imageFile,4);
    cameraParams = fungCalibration(road,imageFile)
    %save('cameraParams','cameraParams')
    %load cameraParams;
    figure
    fileName = fullfile(dataDir(),road,'Images',imageFile);
    img = imread(fileName);
    imshow(img)
    [assets, pVehicles, assetInfo] = findAssetsInImage(assets,image,cameraParams)
    plotAssets(assets,'SNSF',true)
    
end