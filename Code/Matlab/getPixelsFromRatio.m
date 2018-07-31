function [u,v,phi,psi] = getPixelsFromRatio(x,y,z,dL1Lambda,dL2Lambda,m,n,cx,cy)
% beta : L/lambda 
% m : number of pixels across in image 
% n : number of pixels up/down in image

% first use collapseOntoPlane to find the angles between the camera
% co-ordinate planes:
[phi,psi] = collapseOntoPlane(x,y,z);
% transform using trig
u =  dL1Lambda*m*tan(phi) + cx;
v = -dL2Lambda*n*tan(psi) + cy;

