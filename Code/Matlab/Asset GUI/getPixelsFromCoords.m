function [u,v] = getPixelsFromCoords(coordinates,cameraParams)
%getPixelsFromCoords calculate the pixels that the position (x,y,z) in an image taken by a calibrated camera. 
%
%   INPUTS:
%       coordinates: Coordinates relative to the vehicle to be found [(3,1) ARRAY]
%       cameraParams: Paramers of calibrated camera [STRUCT]
%   OUTPUTS:
%       [u,v]: Pixels of the coordinates in the image [INT, INT].

if isstruct(cameraParams)
    % extrinsics
    A = cameraParams.alpha; B = cameraParams.beta; G = cameraParams.gamma;
    x0 = cameraParams.x0; y0 = cameraParams.y0; h = cameraParams.h; 
    % intrinsics
    fu = cameraParams.fu; fv = cameraParams.fv;   
    m = cameraParams.m; n = cameraParams.n;
    
    if isfield(cameraParams,'cu')
        cu = cameraParams.cu; cv = cameraParams.cv;
    else
        cu = 0; cv = 0;
    end

    if isfield(cameraParams,'k1') == 1
        %radial 
        k1 = cameraParams.k1;
        % tangential
        p1 = cameraParams.p1;
        % centre point    
    else
       k1 = 0; p1 = 0;
    end
else
   A = cameraParams(1); B = cameraParams(2); G = cameraParams(3);
   x0 = cameraParams(4); y0 = cameraParams(5); h = cameraParams(6);
   fu = cameraParams(7); fv = cameraParams(8); 
   cu = cameraParams(9); cv = cameraParams(10);
   %m = cameraParams(11); n = cameraParams(12);
   m = 2464; n = 2056;
   p1 = 0; k1 = 0; 
end


% Rotations
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
% Translation
T = [x0, y0, h]';

Xw = coordinates; % X in the world
Xc = R*Xw - T; % X relative to the camera


% converting to pixels
uDist = fu*Xc(2)/Xc(1); % this is from the centre of the image
vDist = fv*Xc(3)/Xc(1);

% distortions
r = sqrt((uDist-cu)^2 + (vDist-cv)^2);
uUndist = uDist + (uDist-cu)*(k1*r^2) + p1*((r^2 + 2*(uDist-cu)^2));
vUndist = vDist + (vDist-cv)*(k1*r^2) + 2*p1*(vDist-cv)*(uDist-cu);

% transforming coordinate system to top left
u = uDist + m/2; 
v = -vDist + n/2;