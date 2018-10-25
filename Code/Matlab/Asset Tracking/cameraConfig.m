function config = cameraConfig

%% Year 1
config_1.alpha = 0.02;
config_1.beta = -0.014;
config_1.gamma = -0.02;
config_1.L1 = 0.82;
config_1.L2 = 0.88;
config_1.h = 2.7;
config_1.x0 = 1.58;
config_1.y0 = 0;

config_1.m = 2560; config_1.cx = 1280; % >
config_1.n = 2048; config_1.cy = 1024; % ^

%% Year 2
config_2.alpha = -0.0168;
config_2.beta = -0.143;
config_2.gamma = 0.0086;
config_2.L1 = 0.79;
config_2.L2 = 0.700;
config_2.h = 3.2;
config_2.x0 = 2.05;
config_2.y0 = 0;

config_2.m = 2560; config_2.cx = 1280; % >
config_2.n = 2048; config_2.cy = 1024; % ^
% 
% config_2.alpha = 0.004590941051548;
% config_2.beta = -0.124695058716211;
% config_2.gamma = 0.014753223212661;
% config_2.L1 = 0.756802591202754;
% config_2.L2 = 0.735725852650367;
% config_2.h = 2.815218964809028;
% config_2.x0 = 2.261751133894048;
% config_2.y0 = 0.137702657406921;
% 
% 
% config_2.m = 2560; config_2.cx = 1280; % >
% config_2.n = 2048; config_2.cy = 1024; % ^

%% Year3
config_3.alpha =  0.085461;
config_3.beta = -0.037629;
config_3.gamma = -0.01325;
config_3.L1 = 1.9577;
config_3.L2 = 1.3191;
config_3.h = 3.1653;
config_3.x0 = 3.6798;
config_3.y0 = -0.1221;

config_3.m = 2464; config_3.cx = 1232; % >
config_3.n = 2056; config_3.cy = 1028; % ^

config = containers.Map({'Year1','Year2','Year3'},{config_1,config_2,config_3});