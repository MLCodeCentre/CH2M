function R = toVehicleCoords(W,pan,tilt,roll) 
%toCameraCoords Tranforms the coordinates from the frame of reference of the world to the vehicle. 
%
%   Returns The coordinates a rotated through the 3D rotation matrix defined by the pan,
%   tilt and roll angle of the vehicle. 
%
%   INPUTS:
%       W: Coordinates (x,y,z) in the world frame of reference [(1,3) ARRAY].
%       pan: Pan (heading) angle of the vehicle (about the z axis) [FLOAT].
%       tilt: Tilt angle of the vehicle (about the y axis) [FLOAT].
%       roll: Roll angle of the vehicle (about the x axis) [FLOAT].
%   OUTPUTS:
%       R: Coordinates (x,y,z) in the vehicle frame of reference [(1,3) ARRAY].

RotRoad = rotz(pan)*roty(tilt)*rotx(roll);
% getting displacement vector in that new co-ordinate system
R = RotRoad*W;
% This is a quick fix, the heading the angle from the Northing. The vector
% is now [x,y,z] wiht x down the road, y across the road and z height.
R = [R(2); R(1); R(3)];