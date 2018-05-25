function angle_difference = infrontOrBehind(easting_target,northing_target,easting_car,northing_car,heading)
% works out if a car with position easting car, northing car and heading
% heading is infront of or behind the target easting_target, northing_target

% calcute the angle between target and car, if greater than 180 then
% behind.

angle_between = atan((northing_target-northing_car)./(easting_target-easting_car));
% to degrees
angle_between = wrapTo360(rad2deg(angle_between));
angle_difference = abs(heading - angle_between);
