function XYxy

close all;
params = config();

X = 1:0.1:2;
Y = zeros();
Z = 0;

[x_img,y_img] = getImagePlaneCoords(X,Y,Z,params.Z0, ...
                                    params.r1,params.r2,params.r3,...
                                    params.lambda,params.theta,params.alpha);

plot(X,Y)
legend('World Y=X')
figure;
plot(x_img, y_img)
legend('Image Plane')
axis equal