function findRoad(X)

close all;

img_file = fullfile(dataDir(),'A27','Year2','Images','2_2367_1174.jpg');
I = imread(img_file);
imshow(I);
hold on

A = X(1); 
B = X(2);
G = X(3);
L1 = X(4);
L2 = X(5);
h = X(6);


params = config();

% define table co-ordinates relative to the camera
X = -2:0.5:1.62 + 2 + 1.62;
X = X - params.r1;

Y = 5.8:50;
Y = Y - params.r2;
z = -h;

m = 2560; cx = 1280; % >
n = 2048; cy = 1024; % ^


U = [];
V = [];
for x = X
    for y = Y
        u = m*L1*(...
                 (x*(cos(G)*cos(B)) + y*(-sin(G)*cos(A) + cos(G)*sin(B)*sin(A)) + z*(sin(G)*sin(A) + cos(G)*sin(B)*cos(A)))/...
                 (x*(sin(G)*cos(B)) + y*(cos(B)*cos(A) + sin(G)*sin(B)*sin(A)) + z*(-cos(G)*sin(A) + sin(G)*sin(B)*cos(A)))...
                 );

        v = n*L2*(...
                 (x*(-sin(B)) + y*(cos(B)*sin(A)) + z*(cos(B)*cos(A)))/...
                 (x*(sin(G)*cos(B)) + y*(cos(B)*cos(A) + sin(G)*sin(B)*sin(A)) + z*(-cos(G)*sin(A) + sin(G)*sin(B)*cos(A)))...
                 );
        u = u + cx;
        v = -v + cy;
        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'r')
    hold on
    U = [];
    V = [];
end

for y = Y
    for x = X
        u = m*L1*(...
                 (x*(cos(G)*cos(B)) + y*(-sin(G)*cos(A) + cos(G)*sin(B)*sin(A)) + z*(sin(G)*sin(A) + cos(G)*sin(B)*cos(A)))/...
                 (x*(sin(G)*cos(B)) + y*(cos(B)*cos(A) + sin(G)*sin(B)*sin(A)) + z*(-cos(G)*sin(A) + sin(G)*sin(B)*cos(A)))...
                 );

        v = n*L2*(...
                 (x*(-sin(B)) + y*(cos(B)*sin(A)) + z*(cos(B)*cos(A)))/...
                 (x*(sin(G)*cos(B)) + y*(cos(B)*cos(A) + sin(G)*sin(B)*sin(A)) + z*(-cos(G)*sin(A) + sin(G)*sin(B)*cos(A)))...
                 );
        u = u + cx;
        v = -v + cy;
        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'r')
    hold on
    U = [];
    V = [];
end