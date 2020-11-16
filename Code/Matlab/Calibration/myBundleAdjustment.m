function fval = myBundleAdjustment(pointCoords,coordsPost,pixels,cameraParams)

% refine world coordinates.
error = [];
pixels = reshape(pixels,[],2);
nCoords = size(pixels,1);

for iCoord = 1:nCoords    
    coordsPoint = [0,pointCoords(2*iCoord-1),pointCoords(2*iCoord)];
    [u,v] = getPixelsFromCoords(coordsPoint'+coordsPost',cameraParams);
    uTarget = pixels(iCoord,1);
    vTarget = pixels(iCoord,2);
    error(end+1) = u-uTarget;
    error(end+1) = v-vTarget;
end

fval = norm(error);

end