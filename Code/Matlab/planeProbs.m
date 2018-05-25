function planeProbs
close all
X = 1;
Y = 2:0.01:10;

params = config();
[XX,YY] = meshgrid(X,Y);
Z = zeros(size(XX(:),1),1);

[x_img,y_img] = getImagePlaneCoords(XX,YY,Z,...
                                    params.Z0,params.r1,params.r2,params.r3,...
                                    params.lambda,...
                                    params.theta,params.alpha);
plot(Y,y_img)
xlabel('Y[m]'); ylabel('y Image Plane [m]'); title('X=1, Z=0')

figure
plot(Y,x_img)
xlabel('Y[m]'); ylabel('x Image Plane [m]'); title('X=1, Z=0')
