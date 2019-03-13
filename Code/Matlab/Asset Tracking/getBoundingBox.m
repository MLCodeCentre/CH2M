function [x,y,w,h,U,V] = getBoundingBox(x,y,z,year,length,width,height,camera_params)
% takes in the image table object with accompanying width and height. 
% if width and height aren't provided then 1m for each is assumed. 
params = camera_params(year);

error_buffer = 0.4;
z_error_buffer = 0.2;

x_range = [max(0,x-length/2-error_buffer), x+length/2+error_buffer];
y_range = [y-width/2-error_buffer, y+width/2+error_buffer];
z_range = [z-error_buffer, z+height+z_error_buffer];

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
u_min = max(0,ceil(min(U)));
u_max = min(ceil(max(U)),params.m);
v_min = max(0,ceil(min(V)));
v_max = min(ceil(max(V)),params.n);

x = u_min; w = u_max - u_min;
y = v_min; h = v_max - v_min;

end