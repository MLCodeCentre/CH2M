function config = cameraConfig

%% Year 1
config_1.alpha = 0.005906388;
config_1.beta = -0.005755524;
config_1.gamma = -0.039743306;
config_1.L1 = 0.807010664;
config_1.L2 = 1.072118766;
config_1.h =  2.138873247;
config_1.x0 = 1.853526008;
config_1.y0 = -0.295400226;

config_1.m = 2560; config_1.cx = 1280; % >
config_1.n = 2048; config_1.cy = 1024; % ^

%% Year 2
config_2.alpha = -0.029022844;
config_2.beta = -0.0992300949692205;
config_2.gamma = 0.0148012657417494;
config_2.L1 = 0.790683861608002;
config_2.L2 = 1.06975824202134;
config_2.h = 2.35853896376169;
config_2.x0 = 1.90895106655138;
config_2.y0 = 0.147855024843825;

config_2.m = 2560; config_2.cx = 1280; % >
config_2.n = 2048; config_2.cy = 1024; % ^

%% Year3
config_3.alpha =  0.0738;
config_3.beta = -0.0411;
config_3.gamma = -0.047;
config_3.L1 = 2.1053;
config_3.L2 = 1.6158;
config_3.h = 3.3225;
config_3.x0 = 2.4227;
config_3.y0 = -0.1775;

config_3.m = 2464; config_3.cx = 1232; % >
config_3.n = 2056; config_3.cy = 1028; % ^

config = containers.Map({'Year1','Year2','Year3'},{config_1,config_2,config_3});