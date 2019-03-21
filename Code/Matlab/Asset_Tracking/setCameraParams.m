function cameraParams = setCameraParams(dataDir,road)
%setCameraParams Loads camera parameters from calibration_parameters.csv for each year.
%
%   INPUTS:
%       dataDir: Top level directory where data is stored [CHAR].
%       road: Road being analysed [CHAR].
%   OUTPUTS:
%       cameraParams: Loaded camera parameters [STRUCT]

% reading parameters from disk
paramsTable1 = readtable(fullfile(dataDir,road,'Year1','calibration_parameters.csv'));
paramsTable2 = readtable(fullfile(dataDir,road,'Year2','calibration_parameters.csv'));

configYear1 = table2struct(paramsTable1);
configYear2 = table2struct(paramsTable2);
% % year 1
% % extrinsics
% configYear1.alpha = paramsTable1.roll;
% configYear1.beta = paramsTable1.tilt;
% configYear1.gamma = paramsTable1.pan;
% configYear1.h =  paramsTable1.h;
% configYear1.x0 = paramsTable1.x0;
% configYear1.y0 = paramsTable1.y0;
% 
% % intrinsics
% configYear1.sy = paramsTable1.sy;
% configYear1.sz = paramsTable1.sz;
% configYear1.lambda = paramsTable1.lambda;
% configYear1.k1 = paramsTable1.k1;
% configYear1.k2 = paramsTable1.k2;
% configYear1.p1 = paramsTable1.p1;
% configYear1.p2 = paramsTable1.p2;
% 
% configYear1.m = paramsTable1.m; configYear1.cx = paramsTable1.cx; % >
% configYear1.n = paramsTable1.n; configYear1.cy = paramsTable1.cy; % ^
% 
% % year 2
% % extrinsic
% configYear2.alpha = paramsTable2.roll;
% configYear2.beta = paramsTable2.tilt;
% configYear2.gamma = paramsTable2.pan;
% configYear2.h =  paramsTable2.h;
% configYear2.x0 = paramsTable2.x0;
% configYear2.y0 = paramsTable2.y0;
% 
% % intrinsics
% configYear2.sy = paramsTable2.sy;
% configYear2.sz = paramsTable2.sz;
% configYear2.lambda = paramsTable2.lambda;
% configYear2.k1 = paramsTable2.k1;
% configYear2.k2 = paramsTable2.k2;
% configYear2.p1 = paramsTable2.p1;
% configYear2.p2 = paramsTable2.p2;
% 
% configYear2.m = paramsTable2.m; configYear2.cx = paramsTable2.cx; % >
% configYear2.n = paramsTable2.n; configYear2.cy = paramsTable2.cy; % ^

% The parameters for each year can be accessed by cameraParams('Year1')
% and camerParams('Year2')
cameraParams = containers.Map({'Year1','Year2'},{configYear1,configYear2});