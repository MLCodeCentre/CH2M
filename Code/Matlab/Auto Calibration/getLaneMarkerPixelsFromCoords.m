function [u,v] = getLaneMarkerPixelsFromCoords(cameraParams,laneMarker,separation,markerLength)
%getPixelsFromCoords calculate the pixels that the position (x,y,z) in an image taken by a calibrated camera. 
%
%   INPUTS:
%       coordinates: Coordinates relative to the vehicle to be found [(3,1) ARRAY]
%       cameraParams: Paramers of calibrated camera [STRUCT]
%       laneMarker: how many lane markers away from the camera [INT]
%   OUTPUTS:
%       [u,v]: Pixels of the coordinates in the image [INT, INT].

    % extrinsics
    A = cameraParams.alpha; B = cameraParams.beta; G = cameraParams.gamma;
    x0 = cameraParams.x0; y0 = cameraParams.y0; h = cameraParams.h; 
    xm = cameraParams.xm; ym = cameraParams.ym;

    % intrinsics
    fu = cameraParams.fu; fv = cameraParams.fv;
    m = cameraParams.m; n = cameraParams.n;
    
    cameraParams.alpha = 0;

    % Rotations
    R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
          sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
         -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
    % Translation
    T = [x0, y0, h]';

    Xw = [xm + (laneMarker-1)*separation + markerLength, ym, 0]'; % X in the world
    Xc = R*Xw - T; % X relative to the camera

    % converting to pixels
    uDash = fu*Xc(2)/Xc(1); % this is from the centre of the image
    vDash = fv*Xc(3)/Xc(1);

    u = uDash + m/2; % transforming coordinate system to top left
    v = -vDash + n/2;
end