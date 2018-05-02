function R = toCameraCoords(W,theta) 
    % road co-ordinates - rotating through YAW(theta) so that pointing down 
    % the road
    RotRoad = rotz(theta);
    % getting displacement vector in that new co-ordinate system
    R = RotRoad*W;
    % Rotating the Camera againe
end