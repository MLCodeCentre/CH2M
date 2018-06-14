function findTable

close all
% define table co-ordinates relative to the camera
X = -0.245:0.02:0.255;
Y = 0.2:0.2:2.4;
Z = -0.21;

% camera (iphone) ratio found to be 0.45;
dL1Lambda = 0.837752898516639;
dL2Lambda = 1.135597331993913;
m = 4032; cx = 2016; % >
n = 3024; cy = 1512; % ^
alpha = 1.1;
gamma = 0.6;

img_file = fullfile(dataDir(),'Experiment','tablewithstickies.jpg');
I = imread(img_file);
imshow(I);
hold on

us = [];
vs = [];
for y_ind = Y
   for x_ind = X
   disp('-------------------------')
       r_w = [x_ind,y_ind,Z]';
       disp(['rw: ', num2str(r_w(1)),' ', num2str(r_w(2)),' ',num2str(r_w(3))])
       [u_w,v_w,phi_w,psi_w] = getPixelsFromRatio(r_w(1),r_w(2),r_w(3),...
                                                  dL1Lambda,dL2Lambda,m,n,cx,cy);
       disp(['phi_w: ',num2str(rad2deg(phi_w)),' psi_w: ',num2str(rad2deg(psi_w))])
       disp(['u_img_w: ',num2str(u_w-cx),' v_img_w: ',num2str(v_w-cy)])
       %disp(['u_w: ',num2str(u_w),' v_w: ',num2str(u_w)])
       disp(' ')
        
       r_c = rotz(gamma)*rotx(alpha)*r_w;
       disp(['rc: ', num2str(r_c(1)),' ', num2str(r_c(2)),' ',num2str(r_c(3))])
       %plotPlanes(X,y,Z);
       [u_c,v_c,phi_c,psi_c] = getPixelsFromRatio(r_c(1),r_c(2),r_c(3),...
                                                  dL1Lambda,dL2Lambda,m,n,cx,cy);
       disp(['phi_c: ',num2str(rad2deg(phi_c)),' psi_c: ',num2str(rad2deg(psi_c))])
       disp(['u_img_c: ',num2str(u_c-cx),' v_img_c: ',num2str(v_c-cy)])
       %disp(['u_c: ',num2str(u_c),' v_c: ',num2str(u_c)])
       us = [us, u_c];
       vs = [vs, v_c];
           
   end
   plot(us(:),vs(:),'r-')
   us = [];
   vs = [];
end

for x_ind = X
   for y_ind = Y
   disp('-------------------------')
       r_w = [x_ind,y_ind,Z]';
       disp(['rw: ', num2str(r_w(1)),' ', num2str(r_w(2)),' ',num2str(r_w(3))])
       [u_w,v_w,phi_w,psi_w] = getPixelsFromRatio(r_w(1),r_w(2),r_w(3),...
                                                  dL1Lambda,dL2Lambda,m,n,cx,cy);
       disp(['phi_w: ',num2str(rad2deg(phi_w)),' psi_w: ',num2str(rad2deg(psi_w))])
       disp(['u_img_w: ',num2str(u_w-cx),' v_img_w: ',num2str(v_w-cy)])
       %disp(['u_w: ',num2str(u_w),' v_w: ',num2str(u_w)])
       disp(' ')
        
       r_c = rotz(gamma)*rotx(alpha)*r_w;
       disp(['rc: ', num2str(r_c(1)),' ', num2str(r_c(2)),' ',num2str(r_c(3))])
       %plotPlanes(X,y,Z);
       [u_c,v_c,phi_c,psi_c] = getPixelsFromRatio(r_c(1),r_c(2),r_c(3),...
                                                  dL1Lambda,dL2Lambda,m,n,cx,cy);
       disp(['phi_c: ',num2str(rad2deg(phi_c)),' psi_c: ',num2str(rad2deg(psi_c))])
       disp(['u_img_c: ',num2str(u_c-cx),' v_img_c: ',num2str(v_c-cy)])
       %disp(['u_c: ',num2str(u_c),' v_c: ',num2str(u_c)])
       us = [us, u_c];
       vs = [vs, v_c];
           
   end
   plot(us(:),vs(:),'r-')
   us = [];
   vs = [];
end

