function matlabCalibration(road,year)

% Initialising system parameters and data
if strcmp(year,'Year1')
    cx = 1280; cy = 1024; m = 2560; n = 2048;
elseif strcmp(year,'Year2')
    cx = 1280; cy = 1024; m = 2560; n = 2048;
elseif strcmp(year,'Year3')
    cy = 1;
end
system_params = [cx, cy, m, n];

% loading data
close all
fileDir = fullfile(dataDir(),road,year,'target_data_in_the_plane.csv');
dataPointsTable = readtable(fileDir);
dataPoints = table2array(dataPointsTable(:,2:end));

nPointsImage = 8;
nImages = size(dataPoints,1)/nPointsImage;

imagePoints = dataPoints(:,4:5);
imagePoints = reshape(imagePoints,[nPointsImage,2,nImages]);

worldPoints = dataPoints(:,1:2);
worldPoints = worldPoints(49:56,:) - worldPoints(49,:);

estimateCameraParameters(imagePoints,worldPoints,'WorldUnits','m') 


