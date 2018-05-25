function [u,v] = coords2Pixels(X,Y,Z)

params = config();
[x_img,y_img] = getImagePlaneCoords(X,Y,Z,...
                            params.Z0,params.r1,params.r2,params.r3,...
                            params.lambda,params.theta,params.alpha);

[u,v] = getPixels(x_img,y_img,params.cx,params.cy,params.sx,params.sy);

