function [cameraParams, pointCoords] = hartleyCalibration(road)

close all

pointsLoad = load(sprintf('Correspondences/%s_trackedPoints',road),'trackedPoints');
imageCoordsLoad = load(sprintf('Correspondences/%s_imageCoords',road),'imageCoords');
pointPixels = pointsLoad.trackedPoints;
imageCoords = imageCoordsLoad.imageCoords;

[nImages,nPoints,~] = size(pointPixels);
pointPixels = pointPixels(:,randperm(nPoints),:);
pointPixels = pointPixels(:,1:15,:);
[nImages,nPoints,~] = size(pointPixels);
% setting up camera params and coords to be solved. 
cameraParams0 = [0,0,0,0,0,3,4000];
cameraParamsLB = [-0.1,-0.1,-0.1,-2,-2,0,2000];
cameraParamsUB = [ 0.1, 0.1, 0.1, 2, 2,4,10000];
pointCoords0 = [];
pointCoordsLB = [];
pointCoordsUB = [];
for iPoint = 1:nPoints
   xcoord0 = imageCoords(end,1); 
   ycoord0 = imageCoords(end,2);
   h0 = randi([2,10]);
   pointCoords0 = [pointCoords0,xcoord0,ycoord0,h0];
   pointCoordsLB = [pointCoordsLB,min(imageCoords(:,1))-200,min(imageCoords(:,2))-200,0];
   pointCoordsUB = [pointCoordsUB,max(imageCoords(:,1))+200,max(imageCoords(:,2))+100,10];
end

cameraParamsAndPointCoords0 = [cameraParams0,pointCoords0];
myFunc = @(cameraParamsAndPointCoords) hartleyFunction(cameraParamsAndPointCoords,pointPixels,imageCoords);
LB = [cameraParamsLB, pointCoordsLB];
UB = [cameraParamsUB, pointCoordsUB];
options = optimoptions('ga','Display','iter');
x = ga(myFunc,numel(cameraParamsAndPointCoords0),[],[],[],[],LB,UB,[],options);

cameraParams = [x(1:7), 2464, 2056];
pointCoords = reshape(x(8:end),[],3); 

showReprojections(cameraParams,pointCoords,pointPixels,imageCoords,'M69',1138,7850:7860)

end

function showReprojections(cameraParams,pointCoords,pointPixels,imageCoords,road,PCDATE,PCTIMES)

[nImages,nPoints,~] = size(pointPixels);
for iImage = 1:nImages
    figure
    img = imread(fullfile(dataDir,road,'Images',...
        sprintf('2_%d_%d.jpg',PCDATE,PCTIMES(iImage))));
    imshow(img); hold on;
    scatter(pointPixels(iImage,:,1),pointPixels(iImage,:,2),'o');
    for iPoint = 1:nPoints
        coordsVehicle = toVehicleCoords([pointCoords(iPoint,1:2)-imageCoords(iImage,1:2),pointCoords(iPoint,3)]',...
            imageCoords(iImage,3),0,0)
        [u,v] = projection2D(cameraParams,coordsVehicle);
        plot(u,v,'g+')
    end
end
end