function findTable

close all
% define table co-ordinates relative to the camera
X = -0.025;
Y = 0.1:0.5:2.4;
Z = -0.021;

% camera (iphone) ratio found to be 0.45;
beta = 0.4;
m = 4032; cx = 2016; % >
n = 3024; cy = 1512; % ^

img_file = fullfile(dataDir(),'Experiment','tablewithstickies.jpg');
I = imread(img_file);
imshow(I);
hold on

for y = Y
    [u,v] = getPixelsFromRatio(X,y,Z,beta,m,n,cx,cy)
    plot(u,v,'ro')
end