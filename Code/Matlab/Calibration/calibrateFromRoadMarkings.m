close all
% loads the parsed calibration found in "surveyinfo.xml" files. Lets see
% what happens...

calibration_data_load = load('calibrationDataM69.mat');
calibrationDataTable = calibration_data_load.calibrationData;
calibrationData = [calibrationDataTable.coords_vehicle, ...
    calibrationDataTable.u calibrationDataTable.v];
calibrationData = calibrationData(1:20,:)

%% now solving camera parameters by minising the error. 
intrinsics0 =  2000;
rotations0 = [0,-5,0];
translations0 = [0,0,2.5];

intrinsicsLB =  100;
rotationsLB = [-20,-20,-20];
translationsLB = [-2,-2,0];

intrinsicsUB =  8000;
rotationsUB = [20,20,20];
translationsUB = [20,2,5];

cameraParams0 = [intrinsics0, rotations0, translations0];
cameraParamsLB = [intrinsicsLB, rotationsLB, translationsLB];
cameraParamsUB = [intrinsicsUB, rotationsUB, translationsUB];


%setting up global search
f = @(cameraParams) reprojectionError(calibrationData, cameraParams);
f(cameraParams0)

[cameraParams,fval] = fmincon(f, cameraParams0, [],[],[],[],cameraParamsLB, cameraParamsUB, @vanishingPointConstraint)

% show reprojections
showReprojections(calibrationDataTable, cameraParams);
[~, errors] = reprojectionError(calibrationData, cameraParams);
findRoad(navFileM69, cameraParams)

%% other functions
function [fval, errors] = reprojectionError(calibrationData, cameraParams)
% calculates the MSE reprojection error of coords in calibration data given
% the camera parameters, this of course is to be minimised. 
intrinsics = cameraParams(1);
rotations = cameraParams(2:4);
translations = cameraParams(5:7);

nData = size(calibrationData,1);
for iData = 1:nData
    % compute reprojection error for each data point. 
    [u_project(iData,1),v_project(iData,1)] = ...
        simpleCameraProjection(calibrationData(iData,1:3)', intrinsics,...
        rotations,translations);
end
u_target = calibrationData(:,4);
v_target = calibrationData(:,5);
errors = sqrt((u_project - u_target).^2 + (v_project - v_target).^2);
fval = sum(errors);
end


function [u,v] = simpleCameraProjection(coord, cameraParams, rotation, translation)
m = 2464; n = 2056;
A = deg2rad(rotation(1)); B =  deg2rad(rotation(2)); G = deg2rad(rotation(3));
%x0 = cameraParams(4); y0 = cameraParams(5); h = cameraParams(6);
f = cameraParams(1);
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
% Translation
T = translation';

Xw = coord; % X in the world
Xc = R*Xw - T; % X relative to the camera

% converting to pixels
u =  f*Xc(2)/Xc(1) + m/2;% this is from the centre of the image
v = -f*Xc(3)/Xc(1) + n/2;
end


function showReprojections(calibrationDataTable, cameraParams)
rotations = cameraParams(2:4);
translations = cameraParams(5:7);
intrinsics = cameraParams(1);
current_file = calibrationDataTable(1,:).file_name;
imshow(imread(current_file{1})); hold on;
nPoints = size(calibrationDataTable,1);
for iPoint = 1:nPoints
    plot(calibrationDataTable(iPoint,:).u, calibrationDataTable(iPoint,:).v, 'r+')
    [u,v] = simpleCameraProjection(calibrationDataTable(iPoint,1:3).coords_vehicle',...
        intrinsics,rotations,translations);
    plot(u, v, 'go');
end
end


function findRoad(navFile, cameraParams)
    % camera parameters
    rotations = cameraParams(2:4);
    translations = cameraParams(5:7);
    intrinsics = cameraParams(1);
    
    navImage = navFile(navFile.PCTIME == 7959, :);
    heading = navImage.HEADING;
    vehicle = [navImage.XCOORD; navImage.YCOORD; 0];
    % road coordinates relative to vehicle.
    BR = toVehicleCoords([454090.583; 300652.532; 0] - vehicle,heading,0,0);
    BL = toVehicleCoords([454091.546; 300659.927; 0] - vehicle,heading,0,0);
    TR = toVehicleCoords([454122.738; 300647.296; 0] - vehicle,heading,0,0);
    TL = toVehicleCoords([454123.876; 300654.630; 0] - vehicle,heading,0,0);
    
    figure; img = loadImage(navImage,'M69'); imshow(img); hold on
    xrange = min(BR(1),BL(1)):1:max(TR(1),TL(1));
    yrange = min(BR(2),BL(2)):1:max(TR(2),TL(2));
    for x = xrange
        for y = yrange
            [u,v] = simpleCameraProjection([x;y;0],...
                intrinsics,rotations,translations);
            plot(u,v,'r*')
        end
    end
       
    
end