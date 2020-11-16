function fval = hartleyFunction(cameraParamsAndPointCoords,pointPixels,imageCoords)

cameraParams = cameraParamsAndPointCoords(1:7);
cameraParams = [cameraParams, 2464, 2056];

pointCoords = cameraParamsAndPointCoords(8:end);
pointCoords = reshape(pointCoords,3,[])';

[nImages,nPoints,~] = size(pointPixels);
pixelDist = [];
for iImage = 1:nImages
    for iPoint = 1:nPoints
        % convert point coord to vehicle coords
        coordsVehicle = toVehicleCoords([pointCoords(iPoint,1:2)-imageCoords(iImage,1:2),pointCoords(iPoint,3)]',...
            imageCoords(iImage,3),0,0);
        % project coords onto images
        [u,v] = projection2D(cameraParams,coordsVehicle + [1e-2;0;0]);
        pointPixelsImage = reshape(pointPixels(iImage,iPoint,:),[],2);
        %pixelDist(end+1) = pdist2(pointPixelsImage,[u,v]);
        pixelDist(end+1) = sqrt((pointPixelsImage(1)-u)^2 + (pointPixelsImage(2)-v)^2);
        if isnan(pixelDist(end))
           disp('') 
        end
    end
end
fval = norm(pixelDist);
end