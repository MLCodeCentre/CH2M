function R = toCameraCoords(W,pan,tilt,roll) 
    % road co-ordinates - rotating through YAW(theta) so that pointing down 
    % the road
    RotRoad = rotz(pan)*roty(tilt)*rotx(roll);
    % getting displacement vector in that new co-ordinate system
    R = RotRoad*W;
    % Rotating the Camera again
end