function cameraParams = loadCameraParams(road)
% LOADCAMERAPARAMS loads camera parameters from CSV file returns parameters
% as a struct. 
    folder = fullfile(dataDir(),road,'Calibration');
    cameraParamTable = readtable(fullfile(folder,'camera_parameters.csv'));
    cameraParams = table2struct(cameraParamTable);
end