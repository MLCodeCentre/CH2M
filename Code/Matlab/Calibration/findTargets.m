function findTargets(data_points,theta,system_params)
    
    
    params.alpha = theta(1); params.beta = theta(2); params.gamma = theta(3);
    params.L1 = theta(4); params.L2 = theta(5);
    params.h = theta(6); params.x0 = theta(7); params.y0 = theta(8);
    
    params.cx = system_params(1); params.cy = system_params(2); 
    params.m = system_params(3); params.n = system_params(4);

    image_file = data_points(1,:).image_file;
    I = imread(image_file{1});
    imshow(I);
    hold on
    
    num_data_points = size(data_points,1);
    for i = 1:num_data_points
       data_point = data_points(i,:);
       plot(data_point.u, data_point.v, 'r+')
       
       [u,v] = getPixelsFromCoords(data_point.x,data_point.y,data_point.z,params);
       plot(u,v,'bo');
       
       F(2*i-i) = u - data_point.u;
       F(2*i) = v - data_point.v;
    end
norm(F);
end