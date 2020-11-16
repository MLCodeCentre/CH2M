function [c,ceq] = calibrationConstraints(theta,systemParams,vanishingPoints)
%CALIBRATIONCONSTRAINTS - imposes constraints on the calibration
%optimisations from the vanishing point of the image. 

c = []; %  <= 0, inline with official documentation
%ceq = []; % = 0.

% extrinsics
alpha = theta(1); beta = theta(2); gamma = theta(3);
x0 = theta(4); y0 = theta(5); h = theta(6);
% intrinsics
fu = theta(7); fv = theta(7);
% system params
m = systemParams(1); n = systemParams(2);

% vanishing points
uInf = vanishingPoints(1) - m/2; vInf = -vanishingPoints(2) + n/2;
% constraints
ceq = [uInf - fu*tan(gamma),vInf - fv*tan(beta)/cos(gamma)];
end