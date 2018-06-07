function params = config()
    % define parameters
    params.Z0 = 2.5; % height of camera
    params.alpha = 0; % angle rotated around X axis in degrees
    params.lambda = 0.05; % camera focal length
    
    params.cy = 1024; params.cx = 1280; % focal centre of camera
    %params.sy = 1.2e-05; % defined by the aspect ratio
    params.n = 2048; params.m = 2560; %height, width of image 
    
    %% These parameters are set from cam_geo.csv
    cam_geo = readtable(fullfile(dataDir(),'A27','Year2','cam_geo.csv'));
    %params.theta = cam_geo.CAM2_THETA; % extra tilt
    params.theta = 0;
    params.r1 = cam_geo.CAM2_LVRX/1000;
    params.r2 = cam_geo.CAM2_LVRY/1000; 
    params.r3 = cam_geo.CAM2_LVRZ/1000; % position of camera on fixing
    
    %% try constraining sy and lambda by the vanishing point
    %params.sy = 2.2e-05;
    params.sy = -(params.lambda/tan(deg2rad(params.alpha))) * (1/(780-params.cy));
    params.sx = params.sy/0.8;% effective pixel size of X,Y;

    % intrinsic parameters
    params.alpha_x = 1040;
    params.alpha_y = 1040;
    params.gamma = 0;
end 