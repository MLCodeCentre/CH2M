function referenceMarkerCalibration
% load data
referenceMarkerData = readtable(fullfile(dataDir(),'M69','Calibration','referenceMarkerData.csv'));
% referenceMarkerData = referenceMarkerData(1:20,:);
% where image was taken from
gps_coords = table2array(referenceMarkerData(:, {'GPS_x','GPS_y'}));
headings = table2array(referenceMarkerData(:, {'HEADING'}));
asset_coords = table2array(referenceMarkerData(:, {'Marker_x','Marker_y'}));
base_pixels = table2array(referenceMarkerData(:, {'u_b','v_b'}));
top_pixels = table2array(referenceMarkerData(:, {'u_t','v_t'}));

% initialise solution vector, this is k, xo, y0, h, alpha beta and N*pan.
% lb, x0, ub
fu = [2000,4000,8000]; %fv = [2000,4000,8000];
cu = [-3000,0,3000]; cv = [-3000,0,3000];
x0 = [0,0,0]; y0 = [0,0,0]; h = [1,3,10];
alpha = [0,0,0]; beta = [-90,0,10]; gamma = [-30,0,30];

theta0 = [fu(2), cu(2), cv(2), x0(2), y0(2), h(2), alpha(2), beta(2), gamma(2), 0.5];
thetaLB = [fu(1), cu(1), cv(1), x0(1), y0(1), h(1), alpha(1), beta(1), gamma(1), 0.3];
thetaUB = [fu(3), cu(3), cv(3), x0(3), y0(3), h(3), alpha(3), beta(3), gamma(3), 1.5];

%% Optimisation
f = @(theta) reprojectionError(theta, gps_coords, headings, asset_coords, base_pixels, top_pixels);
solver = 'fmincon';
switch solver
    case 'multi'
        disp('Running multsearch')
        options = optimset('TolFun',1e-16,'TolX',1e-16);
        problem = createOptimProblem('fmincon','objective',f,'x0',...
            theta0,'lb',thetaLB,'ub',thetaUB,'options',options);
        ms = MultiStart('Display','iter');
        [x,fval] = run(ms,problem,50);
    case 'global'
        disp('Running global search')
        options = optimset('TolFun',1e-16,'TolX',1e-16);
        problem = createOptimProblem('fmincon','objective',f,'x0',...
            theta0,'lb',thetaLB,'ub',thetaUB,'options',options);
        gs = GlobalSearch('Display','iter');
        [x,fval] = run(gs,problem);
    case 'ga'
        disp('Running genetic algorithm')
        options = optimoptions(@ga,'MutationFcn',@mutationadaptfeasible,'Generations',100);
        options = optimoptions(options,'Display','iter');
        [x,fval] = ga(f,numel(theta0),[],[],[],[],thetaLB,thetaUB,[],options);
    case 'fmincon'
        [x,fval] = fmincon(f,theta0,[],[],[],[],thetaLB,thetaUB);
    otherwise
        disp('please choose a valid solver');
        exit(0);
end

% results
cameraParams = x;
f = cameraParams(1); cu = cameraParams(2); cv = cameraParams(3);
x0 = cameraParams(4); y0 = cameraParams(5); h = cameraParams(6);
alpha = cameraParams(7); beta = cameraParams(8); gamma = cameraParams(9);
marker_size = cameraParams(10);

fprintf('Solved with reprojection error: %4.2f\n',fval)
fprintf('f: %4.2f, cu: %4.2f, cv: %4.2f\n',f,cu,cv);
fprintf('x0: %4.2f, y0: %4.2f, h: %4.2f\n',x0,y0,h);
fprintf('alpha: %4.6f, beta: %4.6f, gamma: %4.6f\n',deg2rad(alpha),deg2rad(beta),deg2rad(gamma))
fprintf('marker size: %3.2f', marker_size)
end


function fval = reprojectionError(cameraParams, gps_coords, headings, asset_coords, base_pixels, top_pixels)
m = 2465; n = 2056; marker_height = cameraParams(10);
% unpacking theta
f = cameraParams(1); cu = cameraParams(2); cv = cameraParams(3);
x0 = cameraParams(4); y0 = cameraParams(5); h = cameraParams(6);
alpha = cameraParams(7); beta = cameraParams(8); gamma = cameraParams(9);
% now add pan angles and calculate reprojection error
nMarkers = size(base_pixels,1);
reprojectionErrors = [];
for iMarker = 1:nMarkers
    %% base pixels
    % convert to frame of the vehicle
    asset_coord_gps = [asset_coords(iMarker,:), 0]' - [gps_coords(iMarker,:), 0]';
    R = rotationMatrix(0, 0, deg2rad(headings(iMarker)));
    asset_coords_vehicle = R*asset_coord_gps;
    asset_coords_vehicle = [asset_coords_vehicle(2); asset_coords_vehicle(1); asset_coords_vehicle(3)];
    % convert to frame of the camera
    R = rotationMatrix(alpha, beta, gamma);
    t = [x0; y0; h];
    asset_coord_camera = R*asset_coords_vehicle - t;
    % projection onto image plane
    u = f*(asset_coord_camera(2)/asset_coord_camera(1)) + cu;
    v = f*(asset_coord_camera(3)/asset_coord_camera(1)) + cv;
    % change coord system
    u = u + m/2;
    v = -v + n/2;
    % add reprojection error
    reprojectionErrors(end+1) = u - base_pixels(iMarker,1);
    reprojectionErrors(end+1) = v - base_pixels(iMarker,2);
    %% top pixels
    asset_coord_gps = [asset_coords(iMarker,:), marker_height]' - [gps_coords(iMarker,:), 0]';
    R = rotationMatrix(0, 0, deg2rad(headings(iMarker)));
    asset_coords_vehicle = R*asset_coord_gps;
    asset_coords_vehicle = [asset_coords_vehicle(2); asset_coords_vehicle(1); asset_coords_vehicle(3)];
    % convert to frame of the camera
    R = rotationMatrix(alpha, beta, gamma);
    t = [x0; y0; h];
    asset_coord_camera = R*asset_coords_vehicle - t;
    % projection onto image plane
    u = f*(asset_coord_camera(2)/asset_coord_camera(1)) + cu;
    v = f*(asset_coord_camera(3)/asset_coord_camera(1)) + cv;
    % change coord system
    u = u + m/2;
    v = -v + n/2;
    % add reprojection error
    reprojectionErrors(end+1) = u - top_pixels(iMarker,1);
    reprojectionErrors(end+1) = v - top_pixels(iMarker,2);
end
fval = norm(reprojectionErrors);
end

function R = rotationMatrix(alpha, beta, gamma)
    A = alpha; B = beta; G = gamma;
    R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
          sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
         -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
end