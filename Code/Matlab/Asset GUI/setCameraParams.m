function cameraParams = setCameraParams(dataDir,road)
%setCameraParams Loads camera parameters from calibration_parameters.csv for each year.
%
%   INPUTS:
%       dataDir: Top level directory where data is stored [CHAR].
%       road: Road being analysed [CHAR].
%   OUTPUTS:
%       cameraParams: Loaded camera parameters [STRUCT]

% reading parameters from disk
paramTable = readtable(fullfile(dataDir,road,'Calibration','calibration_parameters_simple.csv'));
cameraParams = table2struct(paramTable);
