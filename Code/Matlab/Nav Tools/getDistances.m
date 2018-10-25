function getDistances

theta = 279.33;

% Easting and Northing
light1 = toCameraCoords([471308.243; 105934.029; 0],theta,0,0);
light2 = toCameraCoords([471268.121; 105939.688; 0],theta,0,0);
% I have to co-ordinates of where the photo was taken from, however, this
% doesn't account for the fixing. I can actually
photo = toCameraCoords([471321.89; 105924.91; 0],theta,0,0);
shoulder0 = toCameraCoords([471313.404; 105923.927; 0],theta,0,0);

lane_marker_1 = [471316.545; 105927.42; 0];
lane_marker_1_w = toCameraCoords(lane_marker_1,theta,0,0);

lane_marker_2 = [471305.767; 105929.607; 0];
lane_marker_2_w = toCameraCoords(lane_marker_2,theta,0,0);

lane_marker_1_p = lane_marker_1_w-photo
lane_marker_2_p = lane_marker_2_w-photo
shoulder0-photo
% lane_marker0-photo
% % Euclidean Distances
% photo2light1 = norm(photo-light1);
% photo2light2 = norm(photo-light2);
% light12light2 = norm(light1-light2);
% lane2shoulder = norm(lane_marker0-shoulder0);
% lane2photo = norm(lane_marker0-photo);
% shoulder2photo = norm(shoulder0-photo);
% 
% lane_marker0-photo;
% shoulder0-photo;
% 
% 
% disp(strcat(['Distance from camera to street light 1: ',num2str(photo2light1),'m']))
% disp(strcat(['Distance from camera to street light 2: ',num2str(photo2light2),'m']))
% disp(strcat(['Distance from street light 1 to street light 2: ',num2str(light12light2),'m']))
% disp(strcat(['Distance hard shoulder to lane marker at Y=0: ',num2str(lane2shoulder),'m']))
% disp(strcat(['Distance photo to lane marker at Y=0: ',num2str(lane2photo),'m']))
% disp(strcat(['Distance photo to shoulder at Y=0: ',num2str(shoulder2photo),'m']))

disp('New distances')
chevron1 = toCameraCoords([471316.455; 105927.45; 0], theta, 0, 0);
square = toCameraCoords([471294.125; 105930.699; 0], theta, 0, 0);
chevron1 - photo;
square - photo;
shoulder0 - photo;