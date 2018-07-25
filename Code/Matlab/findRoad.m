function findRoad

close all;

img_file = fullfile(dataDir(),'A27','Year2','Images','2_2367_1174.jpg');
I = imread(img_file);
imshow(I);
hold on

params = config();

% define table co-ordinates relative to the camera
X = -2.3:0.1:1.09;
X = X - params.r1;

Y = params.r2:26;
Y = Y - params.r2;
z = -2.5;

m = 2560; cx = 1280; % >
n = 2048; cy = 1024; % ^
A = 0.6835841968e-1, B = 0.9914589887e-1, G = 0.3863973476e-2, L1 = 1.334465402, L2 = 1.576175343
A = 0.9724188492e-1, B = 0.8872637983e-1, G = 0.5931674209e-2, L1 = 1.434725712, L2 = 1.106265542
A = .7026536670, B = .4433739134, G = -1.192219028, L1 = 0.2078083419e-2, L2 = 0.7980890658e-1

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