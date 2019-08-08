function [fval,error] = laneMarkerCameraFunctionIntrinsics(theta,cameraParams,pixels)
    % returns the function val for the pixels and instrinsics given the extrinsics
    % the first row of pixels is the vanishing point, the rest are lane
    % marker
    
    % Intrinsics - an array of [fu, fv]
    cameraParams.fu = theta(1); cameraParams.fv = theta(2);
    
    error = []; % to filled.
    
    % u pixel from vanishing point
    vanishingPoint = pixels(1,:);
    uInfTarget = vanishingPoint.u;  % from the data
    uInfDash = cameraParams.fu*tan(cameraParams.gamma); % from equations
    uInf = uInfDash+(cameraParams.m/2); % changing to origin in top left of image
    error(end+1) = (uInfTarget-uInf); % first error
    
    % v pixel 
    vInfTarget = vanishingPoint.v; % from the data
    vInfDash = -cameraParams.fv*tan(cameraParams.beta)/cos(cameraParams.gamma); % from equations
    vInf = -vInfDash+(cameraParams.n/2); % changing to origin in top left of image
    error(end+1) = (vInfTarget - vInf); % second error
            
    % calculating pixels of the lane markers.
    laneMarkerPixels = pixels(2:end,:);
    nMarkers = size(laneMarkerPixels,1)/2;
    
    for iMarker = 1:nMarkers
        % beginning of marker
        iPixel = 2*iMarker-1;
        [u,v] = getLaneMarkerPixelsFromCoords(cameraParams,iMarker,cameraParams.separation,0);
        error(end+1) = u - laneMarkerPixels(iPixel,:).u;
        error(end+1) = v - laneMarkerPixels(iPixel,:).v;
        % end of marker
        iPixel = 2*iMarker;
        [u,v] = getLaneMarkerPixelsFromCoords(cameraParams,iMarker,cameraParams.separation,cameraParams.laneMarkerLength);       
        error(end+1) = u - laneMarkerPixels(iPixel,:).u;
        error(end+1) = v - laneMarkerPixels(iPixel,:).v;
    end
    fval = norm(error);
end