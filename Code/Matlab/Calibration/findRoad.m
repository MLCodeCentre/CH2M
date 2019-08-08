function findRoad(theta,systemParams,road,year)
%close all;
figure  

if strcmp(year,'Year1')
    img_file = fullfile(dataDir(),road,year,'Images','2_1308_1363.jpg');
elseif strcmp(year,'Year2')
    img_file = fullfile(dataDir(),road,year,'Images','2_2367_1174.jpg');
elseif strcmp(year,'Year3')
    img_file = fullfile(dataDir(),road,year,'Images','2_559_895.jpg');
end

image_nav = getNavFromFile(img_file,road,year);

P = [image_nav.XCOORD; image_nav.YCOORD; 0];

L = [471315.967; 105923.431; 0];
RB = [471316.441; 105927.454; 0];
RT = [471305.767; 105929.607; 0];

LPw = L-P;
RBPw = RB-P;
RTPw = RT-P;

pan = image_nav.HEADING;
tilt = image_nav.PITCH;
roll = image_nav.ROLL;

LPc = toVehicleCoords(LPw,pan,0,0);
RBPc = toVehicleCoords(RBPw,pan,0,0);
RTPc = toVehicleCoords(RTPw,pan,0,0);

% LPc = toVehicleCoords(LPw,pan,0,roll);
% RBPc = toVehicleCoords(RBPw,pan,0,roll);
% RTPc = toVehicleCoords(RTPw,pan,0,roll);
%
xRange = linspace(RBPc(1),RTPc(1),10);
yRange = linspace(LPc(2),RBPc(2),5);

I = imread(img_file);
imshow(I);
hold on

if isstruct(theta)
    params = theta;
else
    %cx = system_params(1); cy = system_params(2); m = system_params(3); n = system_params(4);
    % extrinsics
    params.alpha = theta(1); params.beta = theta(2); params.gamma = theta(3);
    params.x0 = theta(4); params.y0 = theta(5); params.h = theta(6);

    % intrinsics
    params.fu = theta(7); params.fv = theta(7);
%     params.cu = theta(9); params.cv = theta(10);
%     params.k1 = theta(11); params.p1 = theta(12);
    %radial 
     params.m = systemParams(1); params.n = systemParams(2);
end

%% some coords
U = [];
V = [];
z = 0;
for x = linspace(10,40,10)
    for y = linspace(-1.8,1.8,10)        
        [u,v] = getPixelsFromCoords([x,y,z]',params);
        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'bo')
    hold on
    U = [];
    V = [];
end

%% road
U = [];
V = [];
z = 0;

X = xRange;
Y = yRange;

for y = Y
    for x = X
        [u,v] = getPixelsFromCoords([x,y,z]',params);
        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'r')
    hold on
    U = [];
    V = [];
end

U = [];
V = [];

for x = X
    for y = Y
        [u,v] = getPixelsFromCoords([x,y,z]',params);
        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'r')
    hold on
    U = [];
    V = [];
end