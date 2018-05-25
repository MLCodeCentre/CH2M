function getDistances

theta = 279.33;

% Easting and Northing
light1 = toCameraCoords([471308.243; 105934.029; 0],theta);
light2 = toCameraCoords([471268.121; 105939.688; 0],theta);
% I have to co-ordinates of where the photo was taken from, however, this
% doesn't account for the fixing. I can actually
photo = toCameraCoords([471321.89; 105924.91; 0],theta);
shoulder0 = toCameraCoords([471316.158; 105923.598; 0],theta);
lane_marker0 = toCameraCoords([471316.635; 105927.448; 0],theta);
% Euclidean Distances
photo2light1 = norm(photo-light1);
photo2light2 = norm(photo-light2);
light12light2 = norm(light1-light2);
lane2shoulder = norm(lane_marker0-shoulder0);
lane2photo = norm();
shoulder2photo = norm(shoulder0-photo);


disp(strcat(['Distance from camera to street light 1: ',num2str(photo2light1),'m']))
disp(strcat(['Distance from camera to street light 2: ',num2str(photo2light2),'m']))
disp(strcat(['Distance from street light 1 to street light 2: ',num2str(light12light2),'m']))
disp(strcat(['Distance hard shoulder to lane marker at Y=0: ',num2str(lane2shoulder),'m']))
disp(strcat(['Distance photo to lane marker at Y=0: ',num2str(lane2photo),'m']))
disp(strcat(['Distance photo to shoulder at Y=0: ',num2str(shoulder2photo),'m']))


