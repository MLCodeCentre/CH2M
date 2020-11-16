function fval = cameraEquationFunction(theta,coords,systemParams)
% joining parameters that are learnt and known to pass to
% getPixelsFromCoords
% to be found
% extrinsics
cameraParams.alpha = theta(1); cameraParams.beta = theta(2); cameraParams.gamma = theta(3);
cameraParams.x0 = theta(4); cameraParams.y0 = theta(5); cameraParams.h = theta(6);

% intrinsics
cameraParams.fu = theta(7); cameraParams.fv = theta(7);
% cameraParams.cu = theta(9); cameraParams.cv = theta(10);
% cameraParams.k1 = theta(11); cameraParams.p1 = theta(12);

% constants
cameraParams.m = systemParams(1); cameraParams.n = systemParams(2);
% data
x = coords(:,1); y = coords(:,2); z = coords(:,3); 
uTarget = coords(:,4); vTarget = coords(:,5);

error = [];
num_data_points = size(x,1);
for i = 1:num_data_points
    % find pixels and compare against labels
    [u,v] = getPixelsFromCoords([x(i),y(i),z(i)]',cameraParams);
    error(end+1) = (uTarget(i) - u);
    error(end+1) = (vTarget(i) - v);
end

fval = norm(error); % minimise F