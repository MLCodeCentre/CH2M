function Pc = getXYZ(photo, target, heading)

Pw = target - photo;
%Pc - position in camera coords
Pc = toCameraCoords(Pw,heading);

Pc = [Pc(2); Pc(1); Pc(3)];

