function imagePlaneFun

close all
params = config();
% defining road coordinates a meter either side of camera and 20 metres
% long
x = -1:0.2:0.8;

y = 0:1:70;

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
vanish_point = -(params.lambda/(tan(deg2rad(params.alpha))))*(1/params.sy)...
                 + params.cy
zero_point = (params.lambda*((params.Z0*sin(deg2rad(params.alpha))))/...
                           (params.Z0*cos(deg2rad(params.alpha)) + params.lambda))...
              *(1/params.sy)             

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

X_min = (0 - params.cx)*params.sx;
X_max = (params.m - params.cx)*params.sx;
Y_min = -(0 - params.cy)*params.sy;
Y_max = -(params.n - params.cy)*params.sy;

axis([-abs(X_min), abs(X_max), -abs(Y_min), abs(Y_max)])

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

% figure()
% plot(y_img)
% xlabel('Y[m]'); ylabel('y_{img}');
% hold on     
% 
% figure()
% plot(v)
% xlabel('Y[m]'); ylabel('v');
% set(gca,'Ydir','reverse') % this is to reflect the y axis being reversed in images
end %imagePlaneFun


