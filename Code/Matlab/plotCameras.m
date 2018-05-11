function plotCameras

close all
cam_geo = readtable(fullfile(dataDir(),'A27','Year2','cam_geo.csv'));
scale = 1000; % converting data file to m
size = 0.2; % 20 cm camera
alpha = 90; % all cameras rotated 90 degrees from Z axis
h = 1;
origin = [0,0,h];

% setting up figure
figure();
line([0,origin(1)],[0,origin(2)],[0,origin(3)],'LineWidth',3);
text((0.1+origin(1))/2,(0.1+origin(2))/2,(0+origin(3))/2,'h')
hold on;
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
%set(gca, 'YDir','reverse')
grid on
axis equal

%% Plotting Cameras
% Camera 1
R1 = rotx(alpha)*rotz(cam_geo.CAM1_THETA);
cam1Loc = [cam_geo.CAM1_LVRX/scale, cam_geo.CAM1_LVRY/scale, cam_geo.CAM1_LVRZ/scale] + origin;
plotCamera('Location',cam1Loc,...
           'Orientation',R1,'Opacity',0,'size',size);
text(cam1Loc(1),cam1Loc(2),cam1Loc(3),'1')
% plotting vector R_1 from antenna to camera
line([origin(1),cam1Loc(1)],[origin(2),cam1Loc(2)],[origin(3),cam1Loc(3)],...
     'LineWidth',2)
text((origin(1)+cam1Loc(1))/2,(origin(2)+cam1Loc(2))/2,(origin(3)+cam1Loc(3))/2,...
     'R_1')

%% Camera 2
R2 = rotx(alpha)*rotz(cam_geo.CAM2_THETA);
cam2Loc = [cam_geo.CAM2_LVRX/scale, cam_geo.CAM2_LVRY/scale, cam_geo.CAM2_LVRZ/scale] + origin;
plotCamera('Location',cam2Loc,...
           'Orientation',R2,'Opacity',0,'size',size);
text(cam2Loc(1),cam2Loc(2),cam2Loc(3),'2')
% plotting vector R_2 from antenna to camera
line([origin(1),cam2Loc(1)],[origin(2),cam2Loc(2)],[origin(3),cam2Loc(3)],...
     'LineWidth',2)
text((origin(1)+cam2Loc(1))/2,(origin(2)+cam2Loc(2))/2,(origin(3)+cam2Loc(3))/2,...
     'R_2')

%% Camera 3
R3 = rotx(alpha)*rotz(cam_geo.CAM3_THETA);
cam3Loc = [cam_geo.CAM3_LVRX/scale, cam_geo.CAM3_LVRY/scale, cam_geo.CAM3_LVRZ/scale] + origin;
plotCamera('Location',cam3Loc,...
           'Orientation',R3,'Opacity',0,'size',size);
text(cam3Loc(1),cam3Loc(2),cam3Loc(3),'3')
% plotting vector R_3 from antenna to camera
line([origin(1),cam3Loc(1)],[origin(2),cam3Loc(2)],[origin(3),cam3Loc(3)],...
     'LineWidth',2)
text((origin(1)+cam3Loc(1))/2,(origin(2)+cam3Loc(2))/2,(origin(3)+cam3Loc(3))/2,...
     'R_3')

%% Camera 4
R4 = rotx(alpha)*rotz(cam_geo.CAM4_THETA);
cam4Loc = [cam_geo.CAM4_LVRX/scale, cam_geo.CAM4_LVRY/scale, cam_geo.CAM4_LVRZ/scale] + origin;
plotCamera('Location',cam4Loc,...
           'Orientation',R4,'Opacity',0,'size',size);
text(cam4Loc(1),cam4Loc(2),cam4Loc(3),'4')
% plotting vector R_4 from antenna to camera
line([origin(1),cam4Loc(1)],[origin(2),cam4Loc(2)],[origin(3),cam4Loc(3)],...
     'LineWidth',2)
text((origin(1)+cam4Loc(1))/2,(origin(2)+cam4Loc(2))/2,(origin(3)+cam4Loc(3))/2,...
     'R_4')

    