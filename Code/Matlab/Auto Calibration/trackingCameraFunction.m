function [fval,reprojections] = trackingCameraFunction(theta,trackedPoints,trackedCoords)

m = 2464; n = 2056;

nImages = size(trackedPoints,1);
nPoints = size(trackedPoints,2);
cameraParams = [theta(1:9),m,n];

YZ = theta(9:end);
error = [];reprojections = [];

for iImage = 1:nImages
    % unpacking vehicle coordinates
    xPost = trackedCoords(iImage,1);
    yPost = trackedCoords(iImage,2);
    zPost = trackedCoords(iImage,3);
    for iPoint = 1:nPoints
        % unpacking camera parameters and point coordinates        
        yPoint = YZ(2*iPoint-1);
        zPoint = YZ(2*iPoint);
        
        x = xPost;
        y = yPost + yPoint;
        z = zPost + zPoint;
        
        [uProject,vProject] = getPixelsFromCoords([x,y,z]',cameraParams);
        reprojections(end+1,:) = [uProject,vProject];
        uTarget = trackedPoints(iImage,iPoint,1);
        vTarget = trackedPoints(iImage,iPoint,2);
        
        error(end+1) = (uTarget-uProject);
        error(end+1) = (vTarget-vProject);
    end
end

fval = norm(error);
    