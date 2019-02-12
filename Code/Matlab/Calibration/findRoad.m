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

LPc = toCameraCoords(LPw,pan,0,0);
RBPc = toCameraCoords(RBPw,pan,0,0);
RTPc = toCameraCoords(RTPw,pan,0,0);

y_range = LPc(1):0.2:RBPc(1);
x_range = RBPc(2):RTPc(2);

I = imread(img_file);
imshow(I);
hold on

A = theta(1); B = theta(2); G = theta(3);
L1 = theta(4); L2 = theta(5);
h = theta(6);

% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];

params = config();

% define table co-ordinates relative to the camera


%max(x_range)
%min(x_range)
%max(y_range)
%min(y_range)
%y_dist = max(y_range) - min(y_range)

cx = system_params(1); cy = system_params(2); m = system_params(3); n = system_params(4);
%x0 = system_params(5); y0 = system_params(6);

x0 = theta(7); y0 = theta(8);


%% find coordinates of road on picture
U = [];
V = [];
x = 10;
for z = 0:3
    for y = -7:7        
        u = m*L1*((R(2,1)*(x-x0) + R(2,2)*(y-y0) + R(2,3)*(z-h))...
                 /(R(1,1)*(x-x0) + R(1,2)*(y-y0) + R(1,3)*(z-h))) + cx;

        v = -n*L2*((R(3,1)*(x-x0) + R(3,2)*(y-y0) + R(3,3)*(z-h))...
                  /(R(1,1)*(x-x0) + R(1,2)*(y-y0) + R(1,3)*(z-h))) + cy;

        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'bo')
    hold on
    U = [];
    V = [];
end

U = [];
V = [];
z = 0;

X = x_range;
Y = y_range;



for y = Y
    for x = X
        u = m*L1*((R(2,1)*(x-x0) + R(2,2)*(y-y0) + R(2,3)*(z-h))...
                 /(R(1,1)*(x-x0) + R(1,2)*(y-y0) + R(1,3)*(z-h))) + cx;

        v = -n*L2*((R(3,1)*(x-x0) + R(3,2)*(y-y0) + R(3,3)*(z-h))...
                  /(R(1,1)*(x-x0) + R(1,2)*(y-y0) + R(1,3)*(z-h))) + cy;

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
        u = m*L1*((R(2,1)*(x-x0) + R(2,2)*(y-y0) + R(2,3)*(z-h))...
                 /(R(1,1)*(x-x0) + R(1,2)*(y-y0) + R(1,3)*(z-h))) + cx;

        v = -n*L2*((R(3,1)*(x-x0) + R(3,2)*(y-y0) + R(3,3)*(z-h))...
                  /(R(1,1)*(x-x0) + R(1,2)*(y-y0) + R(1,3)*(z-h))) + cy;

        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'r')
    hold on
    U = [];
    V = [];
end