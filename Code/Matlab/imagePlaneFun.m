function imagePlaneFun()

close all
params = config();
x = -1:0.1:1;
y = 0:0.1:20;
Z = 0;
[XX,YY] = meshgrid(x,y);
[x_img,y_img] = getImagePlaneCoords(XX,YY,Z,...
                                    params.Z0,params.r1,params.r2,params.r3,...
                                    params.lambda,...
                                    params.theta,params.alpha);

planeCoords = [x_img(:), y_img(:)];
plot(planeCoords(:,1),planeCoords(:,2),'bo')
xlabel('x [m]'); ylabel('y [m]'); title('Image Plane')
[u,v] = getPixels(x_img,y_img,params.cx,params.cy, ...
                      params.sx,params.sy);

figure();
plot(u,v,'ro')
xlabel('u'); ylabel('x'); title('Pixel Plane')
%axis([0, params.m, 0, params.n])
set(gca,'Ydir','reverse')
end %imagePlaneFun