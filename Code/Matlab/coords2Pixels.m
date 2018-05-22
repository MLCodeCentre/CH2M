function [u,v] = coords2Pixels(X,Y,Z,alpha,sy,lambda)

params = config();
[x_img,y_img] = getImagePlaneCoords(X,Y,Z,...
                            params.Z0,params.r1,params.r2,params.r3,...
                            lambda,params.theta,alpha);

[u,v] = getPixels(x_img,y_img,params.cx,params.cy,sy./0.8,sy);

