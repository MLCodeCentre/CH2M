function [u,v] = getPixelsFromRatio(x,y,z,beta,m,n,cx,cy)
% beta : L/lambda 
% m : number of pixels across in image 
% n : number of pixels up/down in image

% first use collapseOntoPlane to find the angles between the camera
% co-ordinate planes:
[phi,psi] = collapseOntoPlane(y,z,x);
% transform using trig
u = beta*m*tan(phi) + cx;
v = -beta*n*tan(psi)+ cy;

