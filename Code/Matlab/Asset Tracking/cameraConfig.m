function config = cameraConfig

config_2.alpha = -0.009;
config_2.beta = -0.1025;
config_2.gamma = 0.0242;
config_2.L1 = 0.8530;
config_2.L2 = 0.8879;
config_2.h = 2.5;

config_2.m = 2560; config_2.cx = 1280; % >
config_2.n = 2048; config_2.cy = 1024; % ^

config = containers.Map('Year2',config_2);