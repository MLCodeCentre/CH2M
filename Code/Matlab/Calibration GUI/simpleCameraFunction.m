function fval = simpleCameraFunction(theta,coords,systemParams,vanishingPoint)

% extrinsics
cameraParams.alpha = theta(1); cameraParams.beta = theta(2); cameraParams.gamma = theta(3);
cameraParams.x0 = theta(4); cameraParams.y0 = theta(5); cameraParams.h = theta(6);
% intrinsics
cameraParams.fu = theta(7); cameraParams.fv = theta(7);

cameraParams.cu = 0; cameraParams.cv = 0;
cameraParams.s = 0;
cameraParams.k1 = 0; cameraParams.k2 = 0; 
cameraParams.p1 = 0; cameraParams.p2 = 0;

% constants
cameraParams.m = systemParams(1); cameraParams.n = systemParams(2);
% data
x = coords(:,1); y = coords(:,2); z = coords(:,3); 
uTarget = coords(:,4); vTarget = coords(:,5);

nData = size(x,1);

for iData = 1:nData
    % find pixels and compare against labels
    [u,v] = getPixelsFromCoords([x(iData),y(iData),z(iData)]',cameraParams);
    error(2*iData - 1) = uTarget(iData) - u;
    error(2*iData) = vTarget(iData) - v;
end

if ~isempty(vanishingPoint)
    uInfDash = cameraParams.fu*tan(cameraParams.gamma);
    vInfDash = cameraParams.fv*tan(cameraParams.beta)/cos(cameraParams.gamma);

    uInf = uInfDash + cameraParams.m/2;
    vInf = -vInfDash + cameraParams.n/2;

    error(end+1) = (uInf-vanishingPoint(1))^2;
    error(end+1) = (vInf-vanishingPoint(2))^2;
end

fval = norm(error);