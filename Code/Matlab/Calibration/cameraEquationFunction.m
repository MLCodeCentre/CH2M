function F = cameraEquationFunction(theta,coords,system_params)
% joining parameters that are learnt and known to pass to
% getPixelsFromCoords
% to be found
params.alpha = theta(1); params.beta = theta(2); params.gamma = theta(3);
params.L1 = theta(4); params.L2 = theta(5);
params.h = theta(6); params.x0 = theta(7); params.y0 = theta(8);

%radial 
params.k1 = theta(9); params.k2 = theta(10);
% constants
params.cx = system_params(1); params.cy = system_params(2);
params.m = system_params(3); params.n = system_params(4);
% data
x = coords(:,1); y = coords(:,2); z = coords(:,3); 
u_target = coords(:,4); v_target = coords(:,5);

num_data_points = size(x,1);
for i = 1:num_data_points
    % find pixels and compare against labels
    [u,v] = getPixelsFromCoords([x(i),y(i),z(i)]',params);
    F(2*i - 1) = u_target(i) - u;
    F(2*i) = v_target(i) - v;
end

F = norm(F); % minimise F