function imagePlaneFun
close all
params = config();
% defining road coordinates a meter either side of camera and 20 metres
% long
x = -1:0.5:1;

y = 1:0.2:10;

% plotting the road
[XX,YY] = meshgrid(x,y);
Z = zeros(size(XX(:),1),1);
% plot(XX(:),YY(:),'ko');
% scatter3(XX(:), YY(:), Z);
% hold on
% Rot = rotx(params.alpha);
% plotCamera('Location',[0, 0, params.Z0],'Orientation',Rot,'Opacity',0,'size',0.3);
% xlabel('X [m]'); ylabel('Y [m]'); title('Road Points')
% axis equal; grid on

% get corresponding points in the image plane
figure();
Z = 0;
[x_img,y_img] = getImagePlaneCoords(XX,YY,Z,...
                                    params.Z0,params.r1,params.r2,params.r3,...
                                    params.lambda,...
                                    params.theta,params.alpha);

% plotting the found plane coords
planeCoords = [x_img(:), y_img(:)];
plot(planeCoords(:,1),planeCoords(:,2),'bo')
xlabel('x [m]'); ylabel('y [m]'); title('Image Plane')
axis equal; grid on

% getting the corresponding pixels
[u,v] = getPixels(x_img,y_img,...
                  params.cx,params.cy,params.sx,params.sy);

figure();
% overlaying them on an image
img_file = fullfile(dataDir(),'A27','Year2','Images','2_2367_1174.jpg');
I = imread(img_file);
imshow(I);
hold on              
% % plotting them       
plot(u,v,'ro')
xlabel('u'); ylabel('v'); title('Pixel Plane')
axis([0,params.m,0,params.n])
set(gca,'Ydir','reverse') % this is to reflect the y axis being reversed in images
axis equal; grid on
end %imagePlaneFun


