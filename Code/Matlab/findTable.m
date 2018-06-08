function findTable

close all
% define table co-ordinates relative to the camera
X = -0.25;
Y = 0.1:0.1:2.4;
Z = -0.21;

% camera (iphone) ratio found to be 0.45;
beta = 0.98;
m = 4032; cx = 2016; % >
n = 3024; cy = 1512; % ^

img_file = fullfile(dataDir(),'Experiment','tablewithstickies.jpg');
I = imread(img_file);
imshow(I);
hold on

for y_ind = Y
    
   alpha = 5;
   r = rotx(alpha)*[X,y_ind,Z]';
   X = r(1); y = r(2); Z = r(3);
   
   [u,v] = getPixelsFromRatio(X,y,Z,beta,m,n,cx,cy);
   plot(u,v,'ro')
end