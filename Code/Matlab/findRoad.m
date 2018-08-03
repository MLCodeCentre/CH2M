function findRoad(X)

close all;

img_file = fullfile(dataDir(),'A27','Year2','Images','2_2367_1174.jpg');
%img_file = fullfile(dataDir(),'A27','Year2','Images','2_2369_8551.jpg');

I = imread(img_file);
imshow(I);
hold on

A = X(1); 
B = X(2);
G = X(3);
L1 = X(4);
L2 = X(5);
% hopefully this will be known in the future.
h = X(6);

% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];

params = config();

% define table co-ordinates relative to the camera
X = 6:28;
X = X - params.r2;

Y = -2.34:0.2:1.92;
z = -h;

m = 2560; cx = 1280; % >
n = 2048; cy = 1024; % ^


%% find coordinates of road on picture

U = [];
V = [];
for y = Y
    for x = X
        u = m*L1*((R(2,1)*x + R(2,2)*y + R(2,3)*z)...
                 /(R(1,1)*x + R(1,2)*y + R(1,3)*z)) + cx;

        v = -n*L2*((R(3,1)*x + R(3,2)*y + R(3,3)*z)...
                  /(R(1,1)*x + R(1,2)*y + R(1,3)*z)) + cy;

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
        u = m*L1*((R(2,1)*x + R(2,2)*y + R(2,3)*z)...
                 /(R(1,1)*x + R(1,2)*y + R(1,3)*z)) + cx;

        v = -n*L2*((R(3,1)*x + R(3,2)*y + R(3,3)*z)...
                  /(R(1,1)*x + R(1,2)*y + R(1,3)*z)) + cy;

        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'r')
    hold on
    U = [];
    V = [];
end