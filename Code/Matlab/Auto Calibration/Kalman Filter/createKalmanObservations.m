function createKalmanObservations(road,year,navFile,PCDATE,startPCTIME,endPCTIME)
close all

navStart = navFile(navFile.PCDATE==PCDATE&navFile.PCTIME==startPCTIME,:);

objectFrame = imread(fullfile(dataDir,year,road,'Images',sprintf('2_%d_%d.jpg',PCDATE,startPCTIME)));
imshow(objectFrame)
objectRegion=round(getPosition(imrect));
points = detectKAZEFeatures(rgb2gray(objectFrame),'ROI',objectRegion);
%points = points(1:10);
pointImage = insertMarker(objectFrame,points.Location,'+','Color','red');
figure;
imshow(pointImage);

allPoints(1,:,:) = [points.Location];
validity(:,1) = ones(size(points.Location,1),1);

trackedCoords(1,:) = [navStart.XCOORD,navStart.YCOORD,0];

tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,points.Location,objectFrame);

i = 2;
nImages = endPCTIME-startPCTIME+1;

for PCTIME = startPCTIME+1:endPCTIME
nextFrame = imread(fullfile(dataDir,year,road,'Images',sprintf('2_%d_%d.jpg',PCDATE,PCTIME)));
[points,validity(:,i)] = tracker(nextFrame);
allPoints(i,:,:) = points;

navImage = navFile(navFile.PCDATE==PCDATE&navFile.PCTIME==PCTIME,:);
trackedCoords(i,:) = [navImage.XCOORD,navImage.YCOORD,0];

pointImage = insertMarker(nextFrame,points(logical(validity(:,i)),:),'+','Color','red');
figure
imshow(pointImage)
i=i+1;
end

trackedPoints = allPoints(:,sum(validity,2)==nImages,:);
size(trackedPoints)
save('trackedPoints','trackedPoints')
save('trackedCoords','trackedCoords')
end