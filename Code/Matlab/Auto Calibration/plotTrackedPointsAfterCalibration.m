function plotTrackedPointsAfterCalibration(theta,trackedPoints,trackedCoords)

m = 2560; n = 2048;

nImages = size(trackedPoints,1);
nPoints = size(trackedPoints,2);

for iImage = 1:nImages
    figure;
    set(gca,'Ydir','reverse')
    hold on
    % unpacking vehicle coordinates
    vehicleChange = trackedCoords(iImage,:) - trackedCoords(1,:);
    
    for iPoint = 1:nPoints
        % unpacking camera parameters and point coordinates
        cameraParams = [theta(1:8),0,0,m,n];
        xPoint = theta(8+(3*iPoint-2));
        yPoint = theta(8+(3*iPoint-1));
        zPoint = theta(8+(3*iPoint));
        coords = [xPoint,yPoint,zPoint] - vehicleChange;

        uTarget = trackedPoints(iImage,iPoint,1);
        vTarget = trackedPoints(iImage,iPoint,2);       
        
        [u,v] = getPixelsFromCoords(coords',cameraParams);
        scatter(uTarget,vTarget,'k+');
        scatter(u,v,'ro');
    end
end
        