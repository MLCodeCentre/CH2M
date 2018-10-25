function findTable

close all
% define table co-ordinates relative to the camera
X = 0.3:0.1:2.4;
Y = -0.25:0.05:0.25;
z = -0.205;

m = 4032; cx = 2016; % >
n = 3024; cy = 1512; % ^
A = -0.4860912061e-2, B = -0.7090294123e-1, G = -0.7469854833e-2, L1 = .8354517787, L2 = 1.150049223

% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
% camera (iphone) ratio found to be 0.45;


img_file = fullfile(dataDir(),'Experiment','Experiment2','tables.jpeg');
I = imread(img_file);
imshow(I);
hold on

%% find coordinates of table on picture

U = [];
V = [];
for x = X
    for y = Y
        u = m*L1*((R(2,1)*x + R(2,2)*y + R(2,3)*z)...
                 ./(R(1,1)*x + R(1,2)*y + R(1,3)*z)) + cx;

        v = -n*L2*((R(3,1)*x + R(3,2)*y + R(3,3)*z)...
                  ./(R(1,1)*x + R(1,2)*y + R(1,3)*z)) + cy;

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
