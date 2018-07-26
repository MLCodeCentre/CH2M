function findTable

close all
% define table co-ordinates relative to the camera
X = -10:1:10;
y = 60;
Z = -5:1:5;

% camera (iphone) ratio found to be 0.45;

m = 4032; cx = 2016; % >
n = 3024; cy = 1512; % ^
A = 0.7057262982e-1, B = 0.4844516447e-2, G = 0.7467216469e-2, L1 = .8354495188, L2 = 1.146112547


img_file = fullfile(dataDir(),'Experiment','Experiment2','tables.jpeg');
I = imread(img_file);
imshow(I);
hold on

%% find coordinates of table on picture

U = [];
V = [];
for z = Z
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

for z = Z
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

