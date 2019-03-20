function findRansacTargets(data_points,theta,system_params,inlierIdxs)
    
    params.alpha = theta(1); params.beta = theta(2); params.gamma = theta(3);
    %params.Ly = theta(4); params.Lz = theta(5);
    params.L1 = theta(4); params.L2 = theta(5);
    params.h = theta(6); params.x0 = theta(7); params.y0 = theta(8);
    
    params.cx = system_params(1); params.cy = system_params(2); 
    params.m = system_params(3); params.n = system_params(4);
      
    num_data_points = size(data_points,1);
    current_image_file = '';
    image_ind = 1;
    num_images = length(unique(data_points.image_file))
    
    for i = 1:num_data_points
       image_file = data_points(i,:).image_file;
       if strcmp(current_image_file,image_file{1}) == 0
            subplot(ceil(num_images/2),2,image_ind)
            I = imread(image_file{1});
            current_image_file = image_file{1};
            imshow(I);
            hold on
            image_ind = image_ind + 1;
       end
        
       data_point = data_points(i,:);     
       plot(data_point.u, data_point.v, 'k+')
       
      [u,v] = getPixelsFromCoords(data_point.x,data_point.y,data_point.z,params);
      if inlierIdxs(i) == 0
        plot(u,v,'ro');
      else
        plot(u,v,'bo');
      end
    end
end