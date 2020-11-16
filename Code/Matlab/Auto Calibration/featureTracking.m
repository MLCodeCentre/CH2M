function featureTracking(road,navFile,PCDATE,PCTIMES)
%% load first image and select ROI for features
close all
objectFrame = imread(fullfile(dataDir,road,'Images',...
    sprintf('2_%d_%d.jpg',PCDATE,PCTIMES(1))));
[n,m,~] = size(objectFrame);
figure; imshow(objectFrame);
objectRegion=round(getPosition(imrect));
close;
featurePoints = detectKAZEFeatures(rgb2gray(objectFrame),'ROI',objectRegion);

%pointImage = insertMarker(objectFrame,points.Location,'+','Color','red');
%figure;
%imshow(pointImage);

% save pixel coordinates and the image metadata
navImage = navFile(navFile.PCDATE==PCDATE&navFile.PCTIME==PCTIMES(1),:);
imageCoords(1,:) = [navImage.XCOORD,navImage.YCOORD,navImage.HEADING];

points = featurePoints.Location;
%points(:,1) = points(:,1) - m/2;
%points(:,2) = -points(:,2) + n/2;
allPoints(1,:,:) = points;
validity(:,1) = ones(size(points,1),1);

%% set up point tracker and track through images
tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,featurePoints.Location,objectFrame);

i = 2;
for PCTIME = PCTIMES(2:end)
    % get points in the frame
    nextFrame = imread(fullfile(dataDir,road,'Images',...
        sprintf('2_%d_%d.jpg',PCDATE,PCTIME)));
    [points,validity(:,i)] = tracker(nextFrame);
    % save points and image meta data
    navImage = navFile(navFile.PCDATE==PCDATE&navFile.PCTIME==PCTIME,:);
    imageCoords(i,:) = [navImage.XCOORD,navImage.YCOORD,navImage.HEADING];
    %pointImage = insertMarker(nextFrame,points(logical(validity(:,i)),:),'+','Color','red');
    %points(:,1) = points(:,1) - m/2;
    %points(:,2) = -points(:,2) + n/2;
    allPoints(i,:,:) = points;
    i = i + 1;
end
% find points that are in every image and save
nImages = numel(PCTIMES);
trackedPoints = allPoints(:,sum(validity,2)==nImages,:);
size(trackedPoints)
save(sprintf('Correspondences/%s_trackedPoints',road),'trackedPoints')
save(sprintf('Correspondences/%s_imageCoords',road),'imageCoords')

% plotting
figure; i = 1;
for PCTIME = PCTIMES
    nextFrame = imread(fullfile(dataDir,road,'Images',...
    sprintf('2_%d_%d.jpg',PCDATE,PCTIME)));
    trackedPointsImage = reshape(trackedPoints(i,:,:),[],2);
    %trackedPointsImage(:,1) = trackedPointsImage(:,1) + m/2;
    %trackedPointsImage(:,2) = -trackedPointsImage(:,2) + n/2;
    pointImage = insertMarker(nextFrame,trackedPointsImage,'+','Color','red');
    imshow(pointImage)
    i = i+1;
end

end