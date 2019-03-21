function findRoad(theta,system_params,road,year)
%close all;
figure  

if strcmp(year,'Year1')
    img_file = fullfile(dataDir(),road,year,'Images','2_1308_1363.jpg');
elseif strcmp(year,'Year2')
    img_file = fullfile(dataDir(),road,year,'Images','2_2367_1174.jpg');
elseif strcmp(year,'Year3')
    img_file = fullfile(dataDir(),road,year,'Images','2_559_896.jpg');
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
%
x_range = linspace(RBPc(1),RTPc(1),10);
y_range = linspace(LPc(2),RBPc(2),5);

I = imread(img_file);
imshow(I);
hold on

params = config();

%cx = system_params(1); cy = system_params(2); m = system_params(3); n = system_params(4);
% extrinsics
params.alpha = theta(1); params.beta = theta(2); params.gamma = theta(3);
params.h = theta(4); params.x0 = theta(5); params.y0 = theta(6);

% intrinsics
params.fy = theta(7); params.fz = theta(8);
%radial 
params.k1 = theta(9); params.k2 = theta(10);
% tangential
params.p1 = theta(11); params.p2 = theta(12);

params.cx = system_params(1); params.cy = system_params(2); 
params.m = system_params(3); params.n = system_params(4);


%% some coords
U = [];
V = [];
z = 0.6;
for x = 5:15
    for y = -4        
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

X = x_range;
Y = y_range;

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