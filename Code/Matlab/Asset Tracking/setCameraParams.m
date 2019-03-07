function camera_params = setCameraParams(dataDir,road)

params_table_1 = readtable(fullfile(dataDir,road,'Year1','calibration_parameters.csv'));
params_table_2 = readtable(fullfile(dataDir,road,'Year2','calibration_parameters.csv'));

% year 1
config_1.alpha = params_table_1.roll;
config_1.beta = params_table_1.tilt;
config_1.gamma = params_table_1.pan;
config_1.L1 = params_table_1.L1;
config_1.L2 = params_table_1.L2;
config_1.h =  params_table_1.h;
config_1.x0 = params_table_1.x0;
config_1.y0 = params_table_1.y0;

config_1.m = 2560; config_1.cx = 1280; % >
config_1.n = 2048; config_1.cy = 1024; % ^

% year 2
config_2.alpha = params_table_2.roll;
config_2.beta = params_table_2.tilt;
config_2.gamma = params_table_2.pan;
config_2.L1 = params_table_2.L1;
config_2.L2 = params_table_2.L2;
config_2.h =  params_table_2.h;
config_2.x0 = params_table_2.x0;
config_2.y0 = params_table_2.y0;

config_2.m = 2560; config_2.cx = 1280; % >
config_2.n = 2048; config_2.cy = 1024; % ^

camera_params = containers.Map({'Year1','Year2'},{config_1,config_2});