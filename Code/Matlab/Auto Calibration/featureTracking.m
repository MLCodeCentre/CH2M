function featureTracking(road,navFile,PCDATE,startPCTIME,endPCTIME)
close all

points = detectKAZEFeatures(rgb2gray(objectFrame),'ROI',objectRegion);
%points = points(1:10);
pointImage = insertMarker(objectFrame,points.Location,'+','Color','red');
figure;
imshow(pointImage);

allPoints(1,:,:) = [points.Location];
validity(:,1) = ones(size(points.Location,1),1);


tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,points.Location,objectFrame);


for PCTIME = startPCTIME:endPCTIME
nextFrame = imread(fullfile(dataDir,road,'Images',sprintf('2_%d_%d.jpg',PCDATE,PCTIME)));
[points,validity(:,i)] = tracker(nextFrame);

navImage = navFile(navFile.PCDATE==PCDATE&navFile.PCTIME==PCTIME,:);
W = [signpostLocation(1)-navImage.XCOORD,signpostLocation(2)-navImage.YCOORD,0]'; % IMU - SIGNPOST
navNextImage = navFile(navFile.PCDATE==PCDATE&navFile.PCTIME==PCTIME,:);
P = toVehicleCoords(W,navImage.HEADING,0,0); % IN FRAME OF THE VEHICLE
   
trackedCoords(i,:) = P;

pointImage = insertMarker(nextFrame,points(logical(validity(:,i)),:),'+','Color','red');
points(:,1) = points(:,1) - m/2;
points(:,2) = -points(:,2) + n/2;
allPoints(i,:,:) = points;
figure
imshow(pointImage)
i=i+1;
end

trackedPoints = allPoints(:,sum(validity,2)==nImages,:);
size(trackedPoints)
save(sprintf('Correspondences/%strackedPoints',road),'trackedPoints')
save(sprintf('Correspondences/%strackedCoords',road),'trackedCoords')
end