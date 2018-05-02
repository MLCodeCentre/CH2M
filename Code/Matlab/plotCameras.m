function plotCameras

close all
cam_geo = readtable(fullfile(dataDir(),'A27','Year2','cam_geo.csv'));
scale = 1000;
size = 0.2; % 20 cm camera
% along y axis
R1 = rotx(90)*rotz(180);   
plotCamera('Location',[cam_geo.x___CAM1_LVRX/scale, cam_geo.CAM1_LVRY/scale, cam_geo.CAM1_LVRZ/scale],'Orientation',R1,'Opacity',0,'size',0.2);
text(cam_geo.x___CAM1_LVRX/scale, cam_geo.CAM1_LVRY/scale, cam_geo.CAM1_LVRZ/scale,'1')
%plotCamera('Location',[cam_geo.CAM1_LVRY/scale, cam_geo.x___CAM1_LVRX/scale, cam_geo.CAM1_LVRZ/scale],'Orientation',R1,'Opacity',0,'size',0.2);
%text(cam_geo.CAM1_LVRY/scale, cam_geo.x___CAM1_LVRX/scale, cam_geo.CAM1_LVRZ/scale,'1')
hold on

R2 = rotx(90)*rotz(90);
cam = plotCamera('Location',[cam_geo.CAM2_LVRX/scale, cam_geo.CAM2_LVRY/scale, cam_geo.CAM2_LVRZ/scale],'Orientation',R2,'Opacity',0,'size',0.2);
text(cam_geo.CAM2_LVRX/scale, cam_geo.CAM2_LVRY/scale, cam_geo.CAM2_LVRZ/scale,'2')

R3 = rotx(90)*rotz(0); 
cam = plotCamera('Location',[cam_geo.CAM3_LVRX/scale, cam_geo.CAM3_LVRY/scale, cam_geo.CAM3_LVRZ/scale],'Orientation',R3,'Opacity',0,'size',0.2);
text(cam_geo.CAM3_LVRX/scale, cam_geo.CAM3_LVRY/scale, cam_geo.CAM3_LVRZ/scale,'3')
% cam = plotCamera('Location',[cam_geo.CAM3_LVRY/scale, cam_geo.CAM3_LVRX/scale, cam_geo.CAM3_LVRZ/scale],'Orientation',R3,'Opacity',0,'size',0.2);
% text(cam_geo.CAM3_LVRY/scale, cam_geo.CAM3_LVRX/scale, cam_geo.CAM3_LVRZ/scale,'3')

R4 = rotx(90)*rotz(-90); 
cam = plotCamera('Location',[cam_geo.CAM4_LVRX/scale, cam_geo.CAM4_LVRY/scale, cam_geo.CAM4_LVRZ/scale],'Orientation',R4,'Opacity',0,'size',0.2);
text(cam_geo.CAM4_LVRX/scale, cam_geo.CAM4_LVRY/scale, cam_geo.CAM4_LVRZ/scale,'4')

xlabel('RX [m]')
ylabel('RY [m]')
zlabel('RZ [m]')
title('CAM[1,3]\_LVRX and CAM[1,3]\_LVRY as in the data')
set(gca, 'YDir','reverse')
grid on
axis equal
    