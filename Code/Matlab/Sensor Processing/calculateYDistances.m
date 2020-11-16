function avgGradient = calculateYDistances(assets,navFile)
nAssets = size(assets,1);
nNavFile = size(navFile,1);
for iAsset = 1:nAssets
    yDist = [];
    for iNav = 1:nNavFile
        image = navFile(iNav,:);
        asset = assets(iAsset,:);
        %[assetsImage,pVehicles] = findAssetsInImage(assets(iAsset,:),navFile(iNav,:),cameraParams);
        pWorld = [asset.XCOORD;asset.YCOORD;0]-[image.XCOORD;image.YCOORD;0];
        pVehicle = toVehicleCoords(pWorld,image.HEADING,0,0);
        if pVehicle(1) < 50 && pVehicle(2) < 10
            yDist(end+1) = pVehicle(2);
        end
    end
    %plot(yDist)
    grad(iAsset) = var(yDist);
end
avgGradient = mean(grad);