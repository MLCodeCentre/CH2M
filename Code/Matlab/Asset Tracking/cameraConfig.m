function config = cameraConfig

%% Year 1
config_1.alpha = 0.039;
config_1.beta = -0.018;
config_1.gamma = -0.0224;
config_1.L1 = 0.82;
config_1.L2 = 0.79;
config_1.h = 3.02;
config_1.x0 = 1.58;
config_1.y0 = 0;

config_1.m = 2560; config_1.cx = 1280; % >
config_1.n = 2048; config_1.cy = 1024; % ^

%% Year 2
config_2.alpha = -0.014;
config_2.beta = -0.075;
config_2.gamma = 0.0066;
config_2.L1 = 0.814;
config_2.L2 = 1.39;
config_2.h = 1.708;
config_2.x0 = 1.55;
config_2.y0 = 0;

config_2.m = 2560; config_2.cx = 1280; % >
config_2.n = 2048; config_2.cy = 1024; % ^

config = containers.Map({'Year1','Year2'},{config_1,config_2});