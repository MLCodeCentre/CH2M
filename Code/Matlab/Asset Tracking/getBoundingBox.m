function [x,y,w,h,U,V] = getBoundingBox(x,y,z,year,length,width,height,camera_params)
% takes in the image table object with accompanying width and height. 
% if width and height aren't provided then 1m for each is assumed. 
params = camera_params(year);

error_buffer = 0.5;

x_range = [x, x+length];
y_range = [y-width/2-error_buffer, y+width/2+error_buffer];
z_range = [z-error_buffer, z+height+error_buffer];

U = [];
V = [];
for x = x_range
    for y = y_range
        for z = z_range
            [u,v] = getPixelsFromCoords(x,y,z,params);
            U = [U,u]; V = [V,v];
        end
    end
end

% make sure box is in picture. 
u_min = min(U);
u_max = max(U);
v_min = min(V);
v_max = max(V);

x = u_min; w = u_max - u_min;
y = v_min; h = v_max - v_min;

end