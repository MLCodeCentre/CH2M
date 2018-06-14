function findRoad

close all;

img_file = fullfile(dataDir(),'A27','Year2','Images','2_2367_1174.jpg');
I = imread(img_file);
imshow(I);
hold on

dL1Lambda = 0.9;
dL2Lambda = 1.4;

params = config();

alpha = 5;
gamma = 0.3;

X = -2.22:0.5:1.65;
Y = 16.4:55.7;
Z = -2.5;

for x = X
   for y = Y
       r_w = [x,y,Z]';
       r_c = rotz(gamma)*rotx(alpha)*r_w;
       r_c = r_c + [params.r1, params.r2, params.r3]';
       [u,v,phi,psi] = getPixelsFromRatio(r_c(1),r_c(2),r_c(3),...
                                                  dL1Lambda,dL2Lambda,...
                                                  params.m,params.n,...
                                                  params.cx,params.cy);
       plot(u,v,'ro')
   end
end