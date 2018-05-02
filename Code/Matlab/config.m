function params = config()
    % define parameters
    params.Z0 = 0.5; % height of camera
    params.alpha = 110; % angle rotated around X axis 
    params.theta = 0; % extra tilt - should be zero
    params.r1 = 0; params.r2 = 0; params.r3 = 0; % height of camera on fixing
    params.lambda = 0.035; % camera focal length
    params.cy = 1280; params.cx = 1024; % focal centre of camera
    params.sy = 0.00001;% effective pixel size of X,Y
    params.sx = params.sy/0.8; % defined by the aspect ratio
    params.n = 2048; params.m = 2560; %height, width of image  
end