function topDown = getTopDown(year,img,dimensions)
% Returns top down veiw of the road in the image img.
% Dimensions = [buffer, length, half_width]. The section of road to
% transformed is of size length*half_width starting at a length buffer down
% the road. 

buffer_x = dimensions(1); buffer_y = dimensions(2);
length = dimensions(3); width = dimensions(4);
buffer_y = 0;

params_all = cameraConfig();
params = params_all(year);

% get nav file information for heading and location. 
% corners = [TL, TR, BL, BR]
corners = [buffer_x + length, -width/2 + buffer_y;  
           buffer_x + length,  width/2 + buffer_y;
           buffer_x,          -width/2 + buffer_y;  
           buffer_x,           width/2 + buffer_y;];
% This kept flexible so any polygon can be specified in corners. 
num_corners = size(corners,1);
%figure; imshow(img); hold on
for corner_num = 1:num_corners
    % get x,y,z coords of road surface segment and corresponding
    % pixels.
    x = corners(corner_num,1); y = corners(corner_num,2); z = 0; 
    [u,v] = getPixelsFromCoords(x,y,z,params);
    %plot(u,v,'ro')
    polygon(corner_num,:) = [u,v];
    U(corner_num) = u; V(corner_num) = v;         
end
%reordering for cropping tool
U = [U(3), U(1), U(2), U(4)];
V = [V(3), V(1), V(2), V(4)];
% cropping out the polygon:
BW=roipoly(img,U,V);
cropped = img .* uint8(BW);

%% applying projective tranformation, turning the trapezoid into a rectangle
movingPoints = polygon;

[w,h,~] = size(img);
% TL TR BL BR
fixedPoints = [0 0; w 0; 0 h; w h];

tform = fitgeotrans(movingPoints, fixedPoints, 'Projective');
RA = imref2d([h w], [1 size(img,1)], [1 size(img,2)]);
[topDown,~] = imwarp(cropped, tform, 'OutputView', RA);

end